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

// MARK : - WebViewController : UIViewController

class WebViewController: UIViewController {
    
    // MARK : - Property
    @IBOutlet weak var webView: UIWebView!
    var urlString: String?
    var loadingActivity : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let urlString = urlString else {
            return
        }

        let url = NSURL(dataRepresentation:urlString.dataUsingEncoding(NSUTF8StringEncoding)!, relativeToURL:nil)

        webView.loadRequest(NSURLRequest(URL: url))
    }
    
}

// MARK : - WebViewController : UIWebViewDelegate

extension WebViewController : UIWebViewDelegate {
    
    // MARK : - UIWebViewDelegate Methods
    
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
        
        let alertView = UIAlertController(title:"", message: Constants.Alert.Message.WebPageLoadingFail, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: Constants.Alert.Title.Dismiss, style:.Default, handler:nil))
        self.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
}