//
//  ViewController.swift
//  WebServer
//
//  Created by Yujie Zhang on 28/10/15.
//  Copyright © 2015 ZYJ. All rights reserved.
//

import UIKit
import GCDWebServer
import ZipArchive


class RootViewController: UIViewController,GCDWebUploaderDelegate {
    
    var webUploader:GCDWebUploader!
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        webUploader = GCDWebUploader(uploadDirectory: documentsURL?.path)
        webUploader.allowedFileExtensions = ["zip"]
        webUploader.delegate = self
        
        do {
            try webUploader.startWithOptions([GCDWebServerOption_ConnectionClass : WebServerConnection.self,
                GCDWebServerOption_Port:50000,GCDWebServerOption_BonjourName:""])
        } catch  {
            
        }
    }

    func webUploader(uploader: GCDWebUploader!, didUploadFileAtPath path: String!) {
        let fileName = uniqueFileNameBaseOnDate()
        let tempURL = documentsURL?.URLByAppendingPathComponent(fileName, isDirectory: true)
        let zipArchive = ZipArchive(fileManager: NSFileManager.defaultManager())
        zipArchive.UnzipOpenFile(path)
        zipArchive.UnzipFileTo(tempURL?.path, overWrite: true)
        zipArchive.UnzipCloseFile()
    }


    
    func uniqueFileNameBaseOnDate()->String {
        let now = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-hh-mm-ss"
        return dateFormatter.stringFromDate(now)
    }
}

