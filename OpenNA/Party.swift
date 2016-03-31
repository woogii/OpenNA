//
//  Party.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 31..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation


struct Party {
    
    var name:String
    var logo:String?
    var color:Int?
    var id:Int
    var size:Int

    init(dictionary: [String:AnyObject]) {
        
        name  = (dictionary[TPPClient.JSONResponseKeys.PartyName] as! String)
        logo  = dictionary[TPPClient.JSONResponseKeys.PartyLogo] as? String
        color = dictionary[TPPClient.JSONResponseKeys.PartyColor] as? Int
        id    = (dictionary[TPPClient.JSONResponseKeys.PartyId] as! Int)
        size  = (dictionary[TPPClient.JSONResponseKeys.PartySize] as! Int)
    }
    
    static func partiesFromResults(results:[[String:AnyObject]])->[Party] {
        var parties = [Party]()
        
        for result in results {
            parties.append(Party(dictionary:result))
        }
        
        return parties
    }
    
}