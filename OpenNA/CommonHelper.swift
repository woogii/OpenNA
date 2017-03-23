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
  
  
  // MARK : - Draw the text into an Image
  
  class func textToImage(_ drawText: NSString, inImage: UIImage, atPoint:CGPoint, cellSize:CGSize)->UIImage{
    
    // Setup the font specific variables
    let textColor: UIColor = UIColor.black
    let textFont: UIFont = UIFont(name: Constants.Strings.Party.imageTextFont, size: 17)!
    
    //Setup the image context using the passed image.
    //UIGraphicsBeginImageContext(inImage.size)
    UIGraphicsBeginImageContext(cellSize)
    
    //Setups up the font attributes that will be later used to dictate how the text should be drawn
    let textFontAttributes = [
      NSFontAttributeName: textFont,
      NSForegroundColorAttributeName: textColor,
      ]
    
    //Put the image into a rectangle as large as the original image.
    inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
    print("image size : \(inImage.size)")
    print("cell size : \(cellSize)")
    // Creating a point within the space that is as bit as the image.
    //let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width-10, height: inImage.size.height)
    
    let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: cellSize.width-30, height: cellSize.height)
    
    //Now Draw the text into an image.
    drawText.draw(in: rect, withAttributes: textFontAttributes)
    
    // Create a new image out of the images we have created
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    
    // End the context now that we have the image we need
    UIGraphicsEndImageContext()
    
    //And pass it back up to the caller.
    return newImage
    
  }

}


