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
    
    // MARK :  Properties
    var lawmakers    = [Lawmaker]()
    var bills        = [Bill]()
    var parties      = [Party]()
    var searchResult = [String:AnyObject]()
    
    var lawmakerSearchTask: NSURLSessionTask?
    var billSearchTask: NSURLSessionTask?
    var partySearchTask: NSURLSessionTask?
    
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext.init(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
    func searchAll(searchKeyword:String, completionHandler: (lawmakers:[Lawmaker],bills:[Bill], parties:[Party], error:NSError?)->Void) {
        
        lawmakerSearchTask?.cancel()
        partySearchTask?.cancel()
        billSearchTask?.cancel()
        
        // Dispatch group is used as this searchAll function should return the final search results after each individual search operation is performed
        let group = dispatch_group_create()
        
        dispatch_group_enter(group)
        
        // Search keyword with the given search keyword
        self.lawmakerSearchTask = TPPClient.sharedInstance().searchLawmaker(searchKeyword, completionHandler:  { results, error in
            
            if let lawmakerDict = results {
                
                self.lawmakers = lawmakerDict.map() {
                    Lawmaker(dictionary: $0, context: self.scratchContext)
                }
                
                #if DEBUG
                    log.debug("lawmaker count: \(self.lawmakers.count)")
                #endif
            } else {
                #if DEBUG
                    log.debug(error?.localizedDescription)
                #endif
            }
            dispatch_group_leave(group)
        })
        
        dispatch_group_enter(group)
        
        // Search bill with the given search keyword
        self.billSearchTask = TPPClient.sharedInstance().searchBills(searchKeyword, completionHandler:  { bills, error in
            
            if let bills = bills {
                
                #if DEBUG
                    log.debug("bill count: \(bills.count)")
                #endif
                
                self.bills = bills
                
            } else {
                #if DEBUG
                    log.debug(error?.localizedDescription)
                #endif
            }
            dispatch_group_leave(group)
        })
        
        dispatch_group_enter(group)
        
        // Search party with the given search keyword
        self.partySearchTask = TPPClient.sharedInstance().searchParties(searchKeyword, completionHandler:  { parties, error in
            
            if let parties = parties {
                self.parties = parties
                
                #if DEBUG
                    log.debug("party count: \(parties.count)")
                #endif
            } else {
                log.debug(error?.localizedDescription)
            }
            
            dispatch_group_leave(group)
        })
        
        // Wait until all search operations finish
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            #if DEBUG
                log.debug("dispatch group notify")
            #endif
            
            if ( self.lawmakers.count > 0 ||  self.bills.count > 0 || self.parties.count > 0 ) {
                completionHandler(lawmakers:self.lawmakers, bills:self.bills, parties:self.parties, error:nil)
            }
            else {
                #if DEBUG
                    log.debug("empty")
                #endif
                completionHandler(lawmakers:self.lawmakers, bills:self.bills, parties:self.parties, error: NSError(domain: Constants.Error.DomainSearchAll, code: 0, userInfo: [NSLocalizedDescriptionKey:Constants.Error.DescKeyForNoSearchResult]))
            }
            
        }
    }
    
}
