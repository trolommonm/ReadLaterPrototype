//
//  ViewController.swift
//  ReadLaterPrototype
//
//  Created by Alvin Tan De Jun on 19/7/18.
//  Copyright © 2018 Alvin Tan. All rights reserved.
//

import UIKit
import ChameleonFramework
import PopupDialog
import SwiftLinkPreview
import SafariServices

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var linkTitleLabel: UILabel!
    @IBOutlet weak var linkImageView: UIImageView!
    
}

class ViewController: UIViewController {

    var link: String?
    var cononicalLinks: [String] = []
    var linkPreviewDict = SwiftLinkPreview.Response()
    var arrayOfSLPDicts = [SwiftLinkPreview.Response]()
    var slpDescription: String?
    var slpTitle: String?
    var slpCanonicalURL: String?
   
    // testing out plistparser
    var arrayOfDict = PlistParser.myArray {
        didSet {
            PlistParser.saveDataToPlist(array: arrayOfDict)
        }
    }
    
    let textCellIdentifier = "TextCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addLink(_ sender: UIBarButtonItem) {
        showPopUpDialog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.barTintColor = UIColor.flatRedDark
        navigationController?.hidesNavigationBarHairline = true
        
        print("\(arrayOfDict)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showPopUpDialog() {
        
        let popUpVC = PopUpViewController(nibName: "PopUpView", bundle: nil)
        let popUp = PopupDialog(viewController: popUpVC, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false, panGestureDismissal: true, hideStatusBar: false)
        
        let buttonOne = CancelButton(title: "Cancel", height: 60) {
            print("Cancel")
        }
        
        let buttonTwo = DefaultButton(title: "Done", height: 60, dismissOnTap: false) {
            print("Done")
            if let linkTextFieldString = popUpVC.linkTextField.text, !linkTextFieldString.isEmpty {
                self.addLinkPreviews(link: linkTextFieldString)
                popUp.dismiss()
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            } else {
                popUp.shake()
                print("Please enter a link!!")
            }
        }
        
        // Add buttons to dialog
        popUp.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popUp, animated: true, completion: nil)
        
    }
    
    func addLinkPreviews(link: String) {
        print("\(link)")
        let slp = SwiftLinkPreview()
        slp.preview(link, onSuccess: { (result) in
            self.linkPreviewDict = result
            print("\(self.linkPreviewDict)")
            self.setData()
            self.arrayOfSLPDicts.append(result)
            self.tableView.reloadData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            print("In Success...")
            
            // testing out plistparser
            self.arrayOfDict.append(PlistParser.convertSwiftLinkPreview(result: result))
            self.tableView.reloadData()
            }, onError: { (error) in
                print("In error...")
                print("\(error)")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
        )
        
    }
    
    func setData() {
        print("Setting data..")
        if let value: String = self.linkPreviewDict[.canonicalUrl] as? String {
            self.slpCanonicalURL = value
            self.cononicalLinks.append(value)
        }
        
        if let value: String = self.linkPreviewDict[.title] as? String {
            self.slpTitle = value
        }
        
        if let value: String = self.linkPreviewDict[.description] as? String {
            self.slpDescription = value
        }
    }
    
    func loadImage(withImageURL: String) -> UIImage? {
        var image: UIImage?
        if let url = URL(string: withImageURL) {
            do {
                let data = try Data(contentsOf: url)
                image = UIImage(data: data)
            } catch let err {
                image = nil
                print("Error: \(err.localizedDescription)")
            }
        }
        return image
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! TableViewCell
        let row = indexPath.row
        if let title = arrayOfDict[row]["title"], !title.isEmpty {
            cell.linkTitleLabel.text = title
        } else {
            cell.linkTitleLabel.text = "Cannot get title of the link!"
        }
        if let imageLink = arrayOfDict[row]["image"], !imageLink.isEmpty {
            let image = loadImage(withImageURL: imageLink)
            cell.linkImageView.image = image
            cell.linkImageView.contentMode = UIViewContentMode.scaleAspectFill
        } else {
            cell.linkImageView.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = arrayOfSLPDicts[indexPath.row][SwiftLinkResponseKey.finalUrl] as? URL
        let safariViewController = SFSafariViewController(url: url!)
        safariViewController.delegate = self
        
        present(safariViewController, animated: true, completion: nil)
    }
    
}
