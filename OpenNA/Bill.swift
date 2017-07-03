//
//  Bill.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 29..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

// MARK : - Bill

class Bill {
  
  // MARK : - Property
  
  var name:String?
  var proposeDate:String?
  var sponsor:String?
  var status:String?
  var summary:String?
  var documentUrl:String?
  var assemblyId:Int?
  
  // MARK : - Initialization
  
  init(dictionary: [String:AnyObject]) {
    
    name = dictionary[Constants.JSONResponseKeys.BillName] as? String ?? ""
    proposeDate =  dictionary[Constants.JSONResponseKeys.BillProposedDate] as? String ?? ""
    sponsor = dictionary[Constants.JSONResponseKeys.BillSponsor] as? String ?? ""
    status = dictionary[Constants.JSONResponseKeys.BillStatus] as? String ?? ""
    summary = dictionary[Constants.JSONResponseKeys.BillSummary] as? String ?? ""
    documentUrl = dictionary[Constants.JSONResponseKeys.BillDocUrl] as? String ?? ""
    assemblyId  = dictionary[Constants.JSONResponseKeys.BillAssemblyID] as? Int ?? 0
    
  }
  
  init(name:String?,proposeDate:String?,sponsor:String?,status:String?,summary:String?,documentUrl:String?, assemblyId:Int?) {

    self.name         = name
    self.proposeDate  = proposeDate
    self.sponsor      = sponsor
    self.status       = status
    self.summary      = summary
    self.documentUrl  = documentUrl
    self.assemblyId   = assemblyId
    
  }
  

  // MARK : - Helper Method
  
  static func billsFromResults(_ results:[[String:AnyObject]])->[Bill] {
    var bills = [Bill]()
    
    for result in results {
      bills.append(Bill(dictionary:result))
    }
    
    return bills
  }
  
  static func extractBill(from billInList:BillInList)->Bill {
    
    return Bill(name: billInList.name, proposeDate: billInList.proposeDate, sponsor: billInList.sponsor, status: billInList.status, summary: billInList.summary, documentUrl: billInList.documentUrl, assemblyId: billInList.assemblyId as! Int?)
  }
}
