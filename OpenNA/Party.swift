//
//  Party.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 31..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class Party {
    
    var name:String
    var logo:String?
    var color:Int?
    var thumbnail:UIImage?
    var id:Int
    var size:Int?
    
    init(dictionary: [String:AnyObject]) {
        
        name  = (dictionary[Constants.JSONResponseKeys.PartyName] as! String)
        logo  = dictionary[Constants.JSONResponseKeys.PartyLogo] as? String ?? ""
        color = dictionary[Constants.JSONResponseKeys.PartyColor] as? Int
        id    = (dictionary[Constants.JSONResponseKeys.PartyId] as! Int)
        size  = dictionary[Constants.JSONResponseKeys.PartySize] as? Int
        
        let url = NSURL(string: "http://data.popong.com/parties/images/\(id).png")!
        let imageData = NSData(contentsOfURL: url)
        
        
        guard let image = imageData else {
            
            let defaultImage = UIImage(named:"noImage")
            thumbnail = textToImage(name, inImage: defaultImage!, atPoint: CGPointMake(10,60))
            
            return
        }
        
        thumbnail = UIImage(data: image)
        
    }
    

    static func partiesFromResults(results:[[String:AnyObject]])->[Party] {
        var parties = [Party]()
        
        for result in results {
            log.debug("\(result)")
            parties.append(Party(dictionary:result))
        }
        log.debug("\(parties)")
        return parties
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint:CGPoint)->UIImage{
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.blackColor()
        let textFont: UIFont = UIFont(name: "Helvetica Bold", size: 17)!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
}