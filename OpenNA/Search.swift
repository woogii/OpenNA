//
//  SearchResult.swift
//  OpenNA
//
//  Created by Hyun on 2016. 4. 16..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

// MARK : - Search : NSObject

class Search : NSObject {
  
  // MARK :  - Property
  
  var lawmakers    = [Lawmaker]()
  var bills        = [Bill]()
  var parties      = [Party]()
  var searchResult = [String:AnyObject]()
  var lawmakerSearchTask: URLSessionTask?
  var billSearchTask: URLSessionTask?
  var partySearchTask: URLSessionTask?
  
  lazy var scratchContext: NSManagedObjectContext = {
    var context = NSManagedObjectContext.init(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
    return context
  }()
  
  // MARK : - Search All Information
  
  func searchAll(_ searchKeyword:String, completionHandler: @escaping (_ lawmakers:[Lawmaker],_ bills:[Bill], _ parties:[Party], _ error:NSError?)->Void) {
    
    // Cancel all search tasks
    lawmakerSearchTask?.cancel()
    partySearchTask?.cancel()
    billSearchTask?.cancel()
    
    // Variables below will save errors that occur while each search operation performs
    var searchLawmakerError:NSError? = nil
    var searchBillError:NSError? = nil
    var searchPartyError:NSError? = nil
    
    // Dispatch group is used as this function should return the final search results after each individual search operation is done
    let group = DispatchGroup()
    
    group.enter()
    
    // Search keyword with the given search keyword
    self.lawmakerSearchTask = TPPClient.sharedInstance().searchLawmaker(searchKeyword, completionHandler:  { results, error in
      
      if let lawmakerDict = results {
        
        self.lawmakers = lawmakerDict.map() {
          Lawmaker(dictionary: $0, context: self.scratchContext)
        }
        
        #if DEBUG
          print("lawmaker count: \(self.lawmakers.count)")
        #endif
      } else {
        #if DEBUG
          searchLawmakerError = error
          print(error?.localizedDescription as Any)
        #endif
      }
      group.leave()
    })
    
    group.enter()
    
    // Search bill with the given search keyword
    self.billSearchTask = TPPClient.sharedInstance().searchBills(searchKeyword, completionHandler:  { bills, error in
      
      if let bills = bills {
        
        #if DEBUG
          print("bill count: \(bills.count)")
        #endif
        
        self.bills = bills
        
      } else {
        #if DEBUG
          searchBillError = error
          print(error?.localizedDescription as Any)
        #endif
      }
      group.leave()
    })
    
    group.enter()
    
    // Search party with the given search keyword
    self.partySearchTask = TPPClient.sharedInstance().searchParties(searchKeyword, completionHandler:  { parties, error in
      
      if let parties = parties {
        self.parties = parties
        
        #if DEBUG
          print("party count: \(parties.count)")
        #endif
      } else {
        searchPartyError = error
        print(error?.localizedDescription as Any)
      }
      
      group.leave()
    })
    
    // Wait until all search operations finish
    group.notify(queue: DispatchQueue.main) {
      #if DEBUG
        print("dispatch group notify")
      #endif
      var overallError: NSError? = nil
      
      // if there is any error during search operation
      if (searchLawmakerError != nil || searchBillError != nil || searchPartyError != nil ) {
        
        if searchLawmakerError != nil {
          overallError = searchLawmakerError
        } else if searchBillError != nil {
          overallError = searchBillError
        }else{
          overallError = searchPartyError
        }
      }
      
      guard overallError != nil else {
        // return error
        completionHandler(self.lawmakers, self.bills, self.parties, overallError)
        return
      }
      
      if ( self.lawmakers.count > 0 ||  self.bills.count > 0 || self.parties.count > 0 ) {
        completionHandler(self.lawmakers, self.bills, self.parties, nil)
      }
      else {
        #if DEBUG
          print("empty")
        #endif
        completionHandler(self.lawmakers, self.bills, self.parties, NSError(domain: Constants.Error.DomainSearchAll, code: 0, userInfo: [NSLocalizedDescriptionKey:Constants.Error.DescKeyForNoSearchResult]))
      }
      
    }
  }
  
}
