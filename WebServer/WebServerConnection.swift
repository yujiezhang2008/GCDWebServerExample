//
//  WebServerConnection.swift
//  WebServer
//
//  Created by Yujie Zhang on 28/10/15.
//  Copyright © 2015 ZYJ. All rights reserved.
//

import UIKit
import GCDWebServer
import MBProgressHUD

class WebServerConnection: GCDWebServerConnection {
    
    var contentLength:UInt = 0
    var receivedDataLength:UInt = 0
    var progressHUD:MBProgressHUD?
    
    
    override func rewriteRequestURL(url: NSURL!, withMethod method: String!, headers: [NSObject : AnyObject]!) -> NSURL! {
        
        if method == "POST" {
            contentLength = UInt(headers["Content-Length"] as! String)!
            receivedDataLength = 0
            showProgressView()
        }
        return  super.rewriteRequestURL(url, withMethod: method, headers: headers)
    }

    override func didReadBytes(bytes: UnsafePointer<Void>, length: UInt) {
        super.didReadBytes(bytes, length: length)
        
        guard contentLength != 0 else {
            return
        }
        
        receivedDataLength += length
        
        updateProgressView(Float(receivedDataLength) / Float(contentLength))
    }
    
    override func processRequest(request: GCDWebServerRequest!, completion: GCDWebServerCompletionBlock!) {
        super.processRequest(request, completion: completion)
        hideProgressView()
    }
    
    
    func updateProgressView(progress:Float) {
        dispatch_async(dispatch_get_main_queue()) {
            self.progressHUD?.progress = progress
        }
    }

    func showProgressView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.progressHUD = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
            self.progressHUD?.mode = .DeterminateHorizontalBar
            self.progressHUD?.removeFromSuperViewOnHide = true
            
        }
       
    }
    
    func hideProgressView() {
        dispatch_async(dispatch_get_main_queue()) {
            self.progressHUD?.hide(true)
        }
        
    }

}
