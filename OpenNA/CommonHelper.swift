//
//  CommonHelper.swift
//  OpenNA
//
//  Created by TeamSlogup on 2016. 7. 17..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - CommonHelper: NSObject

class CommonHelper: NSObject {
  
  // MARK : Show AlertController
  
  class func showAlertWithMsg(_ controller:UIViewController, msg:String, showCancelButton:Bool ,okButtonTitle:String!, okButtonCallback:(()->Void)?) {
    
    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
    
    let alertOkAction = UIAlertAction(title: okButtonTitle, style: .default) { (action) in
      
      if let okButtonCallback = okButtonCallback {
        
        okButtonCallback()
      }
    }
    
    alert.addAction(alertOkAction)
    
    if showCancelButton {
      
      let cancelAction = UIAlertAction(title: Constants.Alert.Title.Cancel, style: .cancel, handler: nil)
      alert.addAction(cancelAction)
    }
    
    controller.present(alert, animated: true, completion: nil)
  }
  
  
  
}


