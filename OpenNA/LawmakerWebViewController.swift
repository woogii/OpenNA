//
//  LawmakerWebViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 5. 15..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

class LawmakerWebViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    var urlString: String?
    var loadingActivity : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print(urlString)
        
        super.viewWillAppear(animated)
        
        guard let urlString = urlString else {
            return
        }
        
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        loadingActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
        loadingActivity!.labelText = Constants.ActivityIndicatorText.Loading
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        loadingActivity?.hide(true)
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loadingActivity?.hide(true)
        
        let alertView = UIAlertController(title:"", message:"There was a problem loading the web page!", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title:"Dismiss", style:.Default, handler:nil))
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }


}