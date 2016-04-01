//
//  Party.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 31..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

struct Party {
    
    var name:String
    var logo:String?
    var color:Int?
    var thumbnail:UIImage?
    var id:Int
    var size:Int

    init(dictionary: [String:AnyObject]) {
        
        name  = (dictionary[TPPClient.JSONResponseKeys.PartyName] as! String)
        logo  = dictionary[TPPClient.JSONResponseKeys.PartyLogo] as? String ?? ""
        color = dictionary[TPPClient.JSONResponseKeys.PartyColor] as? Int
        id    = (dictionary[TPPClient.JSONResponseKeys.PartyId] as! Int)
        size  = (dictionary[TPPClient.JSONResponseKeys.PartySize] as! Int)

        let url = buildImageURL(id)
        let imageData = NSData(contentsOfURL: url)
        guard let image = imageData else {
            print("in gurad")
            thumbnail = UIImage(named:"noImage")
            return
        }
        thumbnail = UIImage(data: image)

    }
    
    static func partiesFromResults(results:[[String:AnyObject]])->[Party] {
        var parties = [Party]()
        
        for result in results {
            parties.append(Party(dictionary:result))
        }
        
        return parties
    }
    
    func buildImageURL(id:Int)-> NSURL{
        return NSURL(string: "http://data.popong.com/parties/images/\(id).png")!
    }
    
}