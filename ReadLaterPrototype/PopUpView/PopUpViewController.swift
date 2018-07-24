//
//  PopUpViewController.swift
//  ReadLaterPrototype
//
//  Created by Alvin Tan De Jun on 23/7/18.
//  Copyright © 2018 Alvin Tan. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        linkTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }

}

extension PopUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
    
}
