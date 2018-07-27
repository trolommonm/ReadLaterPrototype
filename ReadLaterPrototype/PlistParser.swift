//
//  PlistParser.swift
//  ReadLaterPrototype
//
//  Created by Alvin Tan De Jun on 24/7/18.
//  Copyright © 2018 Alvin Tan. All rights reserved.
//

import Foundation
import SwiftLinkPreview

struct PlistParser {
    
    static var plistPath: String = String()
    
    static var myArray: [[String: String]] = {
        var array: [[String: String]] = []
        
        var rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        var plistPathInDocument = rootPath + "/LinkPreviews.plist"
        if !FileManager.default.fileExists(atPath: plistPathInDocument), let plistPathInBundle = Bundle.main.path(forResource: "LinkPreviews", ofType: "plist") {
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle, toPath: plistPathInDocument)
            } catch {
                print("Error occurered while copying file to document \(error)")
            }
        }
        
        plistPath = plistPathInDocument
        
        let tempArray = NSArray(contentsOfFile: plistPathInDocument)
        if let tempTempArray = tempArray, let value = tempTempArray as? [[String: String]] {
            array = value
        }
        
        return array
    }()

    static func convertSwiftLinkPreview(result: [SwiftLinkResponseKey: Any]) -> [String: String] {
        var dict: [String: String] = [:]
        
        if let value = result[.title] as? String {
            dict["title"] = value
        } else {
            dict["title"] = ""
        }
        
        if let value = result[.image] as? String {
            dict["image"] = value
        } else {
            dict["image"] = ""
        }
        
        if let value = result[.finalUrl] as? NSURL {
            dict["finalUrl"] = value.absoluteString
        } else {
            dict["finalUrl"] = ""
        }
        
        return dict
    }
    
    static func saveDataToPlist(array: [[String: String]]) {
        let arrayToBeSaved: NSArray = array as NSArray
        arrayToBeSaved.write(toFile: plistPath, atomically: true)
    }
    
    static func addData(withDict: [String: String]) {
        myArray.append(withDict)
    }
    
    static func removeData(withDict: [String: String]) {
        for dict in myArray {
            var i = 0
            i += 1
            if dict == withDict {
                myArray.remove(at: i-1)
            }
        }
    }
}
