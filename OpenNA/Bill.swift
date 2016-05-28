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
    var proposeDate:String?
    var sponsor:String?
    var status:String?
    var summary:String?
    var documentUrl:String?
    var assemblyId:Int
    
    // MARK : Initialization
    
    init(dictionary: [String:AnyObject]) {
        
        name = (dictionary[Constants.JSONResponseKeys.BillName] as! String)
        proposeDate =  dictionary[Constants.JSONResponseKeys.BillProposedDate] as? String
        sponsor = (dictionary[Constants.JSONResponseKeys.BillSponsor] as! String)
        status = (dictionary[Constants.JSONResponseKeys.BillStatus] as! String)
        summary = dictionary[Constants.JSONResponseKeys.BillSummary] as? String
        documentUrl = dictionary[Constants.JSONResponseKeys.BillDocUrl] as? String
        assemblyId  = (dictionary[Constants.JSONResponseKeys.BillAssemblyID] as? Int)!
        
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