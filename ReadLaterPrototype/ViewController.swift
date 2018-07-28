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
    
    var plistParser = PlistParser() {
        didSet {
            plistParser.saveDataToPlist()
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
        
        print("\(plistParser.arrayOfDict)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showPopUpDialog() {
        
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
    
    private func addLinkPreviews(link: String) {
        print("\(link)")
        let slp = SwiftLinkPreview()
        slp.preview(link, onSuccess: { (result) in
            
            print("In Success...")
            self.plistParser.addData(withDict: PlistParser.convertSwiftLinkPreview(result: result))
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
            
            }, onError: { (error) in
                
                print("In error...")
                print("\(error)")
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                }
        )
        
    }
    
    private func loadImage(withImageURL: String) -> UIImage? {
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
        return plistParser.arrayOfDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! TableViewCell
        let row = indexPath.row
        if let title = plistParser.arrayOfDict[row]["title"], !title.isEmpty {
            cell.linkTitleLabel.text = title
        } else {
            cell.linkTitleLabel.text = "Cannot get title of the link!"
        }
        if let imageLink = plistParser.arrayOfDict[row]["image"], !imageLink.isEmpty {
            let image = loadImage(withImageURL: imageLink)
            cell.linkImageView.image = image
            cell.linkImageView.contentMode = UIViewContentMode.scaleAspectFill
        } else {
            cell.linkImageView.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let url = plistParser.arrayOfDict[indexPath.row]["finalUrl"], !url.isEmpty {
            let url = URL(string: url)
            let safariViewController = SFSafariViewController(url: url!)
            safariViewController.delegate = self
            
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
}
