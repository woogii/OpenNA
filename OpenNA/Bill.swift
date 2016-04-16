//
//  Bill.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 29..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

class Bill {
    
    // MARK : Properties
    
    var name:String?
    var date:String?
    var sponsor:String?
    var status:String?
    var summary:String?
    
    // MARK : Initialization

    init(dictionary: [String:AnyObject]) {
        
        name = (dictionary[TPPClient.JSONResponseKeys.BillName] as! String)
        date =  dictionary[TPPClient.JSONResponseKeys.BillProposedDate] as? String
        sponsor = (dictionary[TPPClient.JSONResponseKeys.BillSponsor] as! String)
        status = (dictionary[TPPClient.JSONResponseKeys.BillStatus] as! String)
        summary = dictionary[TPPClient.JSONResponseKeys.BillSummary] as? String
    }

    // MARK : Helper Method
    
    static func billsFromResults(results:[[String:AnyObject]])->[Bill] {
        var bills = [Bill]()
    
        for result in results {
            bills.append(Bill(dictionary:result))
        }

        return bills
    }

}