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
    
    var plistPath: String = {
        var rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        var plistPathInDocument = rootPath + "/LinkPreviews.plist"
        
        return plistPathInDocument
    }()
    
    lazy var arrayOfDict: [[String: String]] = {
        var array: [[String: String]] = []
        
        if !FileManager.default.fileExists(atPath: plistPath), let plistPathInBundle = Bundle.main.path(forResource: "LinkPreviews", ofType: "plist") {
            do {
                try FileManager.default.copyItem(atPath: plistPathInBundle, toPath: plistPath)
            } catch {
                print("Error occurered while copying file to document \(error)")
            }
        }
        
        let tempArray = NSArray(contentsOfFile: plistPath)
        if let tempTempArray = tempArray, let value = tempTempArray as? [[String: String]] {
            array = value
        }
        
        return array
    }()
    
    mutating func saveDataToPlist() {
        let arrayToBeSaved: NSArray = arrayOfDict as NSArray
        arrayToBeSaved.write(toFile: plistPath, atomically: true)
    }
    
    mutating func addData(withDict dict: [String: String]) {
        arrayOfDict.append(dict)
    }
    
    mutating func removeData(withDict dict: [String: String]) {
        for dicts in arrayOfDict {
            var i = 0
            i += 1
            if dicts == dict {
                arrayOfDict.remove(at: i-1)
            }
        }
    }
}
