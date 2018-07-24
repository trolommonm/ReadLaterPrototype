//
//  GrabLinkPreview.swift
//  ReadLaterPrototype
//
//  Created by Alvin Tan De Jun on 19/7/18.
//  Copyright © 2018 Alvin Tan. All rights reserved.
//

import Foundation
import SwiftLinkPreview

class GrabLinkPreview {
    var url: String?
    var canonicalURL: String?
    var title: String?
    var desc: String?
    var linkPreviewDict = SwiftLinkPreview.Response()
    
    init(url: String) {
        self.url = url
        let slp = SwiftLinkPreview()
        if let website = slp.extractURL(text: url),
            let cached = slp.cache.slp_getCachedResponse(url: website.absoluteString) {
            
            linkPreviewDict = cached
            setData()
            print("Setting data in cache..")
            
        } else {
            slp.preview(url, onSuccess: { result in
                self.linkPreviewDict = result
                self.setData()
                print("Setting data in preview..")
                //result.forEach { print("\($0), \($1)")}
            }, onError: { (error) in
                print("\(error)") }
            )
        }
        /**if let link = url {
            slp.preview(link, onSuccess: { result in
                self.linkPreviewDict = result
                self.setData()
                //result.forEach { print("\($0), \($1)")}
            }, onError: { (error) in
                print("\(error)") }
            )
        }**/
    }
    
    private func setData() {
        print("Setting data..")
        if let value: String = self.linkPreviewDict[.canonicalUrl] as? String {
            self.canonicalURL = value
        }
        
        if let value: String = self.linkPreviewDict[.title] as? String {
            self.title = value
        }
        
        if let value: String = self.linkPreviewDict[.description] as? String {
            self.desc = value
        }
    }
}
