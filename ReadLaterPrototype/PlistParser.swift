//
//  PlistParser.swift
//  ReadLaterPrototype
//
//  Created by Alvin Tan De Jun on 24/7/18.
//  Copyright © 2018 Alvin Tan. All rights reserved.
//

import Foundation
import UIKit

struct PlistParser {
    
    func retrieveData() {
        var myArray: NSMutableArray?
        if let path = Bundle.main.path(forResource: "LinkPreviews", ofType: "plist") {
            myArray = NSMutableArray(contentsOfFile: path)
        }
        if let array = myArray {
            print("\(array)")
        }
    }
    
    func addData() {
        
    }
    
    func removeData() {
        
    }
}
