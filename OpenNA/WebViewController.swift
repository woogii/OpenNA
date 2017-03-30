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
  var isFromBillDetailVC:Bool?
  var loadingActivity : MBProgressHUD?
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    setNavigationTitle()
  }
  
  func setNavigationTitle() {
    
    if let _ = isFromBillDetailVC {
      navigationItem.title = Constants.Strings.WebVC.Title
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    guard let urlString = urlString else {
      return
    }
    
    let url = URL(dataRepresentation:urlString.data(using: String.Encoding.utf8)!, relativeTo:nil)
    webView.loadRequest(URLRequest(url: url!))
  }
  
  // MARK : - Target Action Method 
  
  @IBAction func pushBackButton(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
  }
  
}

// MARK : - WebViewController : UIWebViewDelegate

extension WebViewController : UIWebViewDelegate {
  
  // MARK : - UIWebViewDelegate Methods
  
  func webViewDidStartLoad(_ webView: UIWebView) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    loadingActivity = MBProgressHUD.showAdded(to: view, animated: true)
    loadingActivity!.label.text = Constants.ActivityIndicatorText.Loading
  }
  
  func webViewDidFinishLoad(_ webView: UIWebView) {
    loadingActivity?.hide(animated:true)
  }
  
  func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
    loadingActivity?.hide(animated:true)
    
    let alertView = UIAlertController(title:"", message: Constants.Alert.Message.WebPageLoadingFail, preferredStyle: .alert)
    alertView.addAction(UIAlertAction(title: Constants.Alert.Title.Dismiss, style:.default, handler:nil))
    self.present(alertView, animated: true, completion: nil)
    
  }
  
}
