//
//  ViewController.swift
//  ReadLaterPrototype
//
//  Created by Alvin Tan De Jun on 19/7/18.
//  Copyright © 2018 Alvin Tan. All rights reserved.
//

import UIKit
import ChameleonFramework

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let slp = GrabLinkPreview(url: "https://medium.com/app-coder-io/33-ios-open-source-libraries-that-will-dominate-2017-4762cf3ce449")
    
    let swiftBlogs = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity"]
    let textCellIdentifier = "TextCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
    
        
        navigationController?.navigationBar.barTintColor = UIColor.flatRedDark
        navigationController?.hidesNavigationBarHairline = true
    }

    override func viewDidAppear(_ animated: Bool) {
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        let row = indexPath.row
        cell.textLabel?.text = swiftBlogs[row]
        return cell
    }

}

