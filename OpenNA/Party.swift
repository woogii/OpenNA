//
//  Party.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 31..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - Party

class Party {
    
    // MARK : - Property
    
    var name:String
    var logo:String?
    var color:Int?
    var thumbnail:UIImage?
    var id:Int
    var size:Int?
    
    // MARK : - Initialization
    
    init(dictionary: [String:AnyObject]) {
        
        name  = (dictionary[Constants.JSONResponseKeys.PartyName] as! String)
        logo  = dictionary[Constants.JSONResponseKeys.PartyLogo] as? String ?? ""
        color = dictionary[Constants.JSONResponseKeys.PartyColor] as? Int
        id    = (dictionary[Constants.JSONResponseKeys.PartyId] as! Int)
        size  = dictionary[Constants.JSONResponseKeys.PartySize] as? Int
    
    }

    // MARK : - Helper Method
    
    static func partiesFromResults(results:[[String:AnyObject]])->[Party] {
        var parties = [Party]()
        
        for result in results {
            #if DEBUG
            log.debug("\(result)")
            #endif
            parties.append(Party(dictionary:result))
        }
        #if DEBUG
        log.debug("\(parties)")
        #endif 
        return parties
    }
    
      
}