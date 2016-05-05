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
        
        name = (dictionary[Constants.JSONResponseKeys.BillName] as! String)
        date =  dictionary[Constants.JSONResponseKeys.BillProposedDate] as? String
        sponsor = (dictionary[Constants.JSONResponseKeys.BillSponsor] as! String)
        status = (dictionary[Constants.JSONResponseKeys.BillStatus] as! String)
        summary = dictionary[Constants.JSONResponseKeys.BillSummary] as? String
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