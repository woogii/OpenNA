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
    var lawmakerSearchTask: NSURLSessionTask?
    var billSearchTask: NSURLSessionTask?
    var partySearchTask: NSURLSessionTask?
    
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext.init(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
    // MARK : - Search All Information
    
    func searchAll(searchKeyword:String, completionHandler: (lawmakers:[Lawmaker],bills:[Bill], parties:[Party], error:NSError?)->Void) {
        
        // Cancel all search tasks
        lawmakerSearchTask?.cancel()
        partySearchTask?.cancel()
        billSearchTask?.cancel()
        
        // Variables below will save errors that occur while each search operation performs
        var searchLawmakerError:NSError? = nil
        var searchBillError:NSError? = nil
        var searchPartyError:NSError? = nil

        // Dispatch group is used as this function should return the final search results after each individual search operation is done
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
                    searchLawmakerError = error
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
                    searchBillError = error
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
                searchPartyError = error
                log.debug(error?.localizedDescription)
            }
            
            dispatch_group_leave(group)
        })
        
        // Wait until all search operations finish
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            #if DEBUG
                log.debug("dispatch group notify")
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
                completionHandler(lawmakers:self.lawmakers, bills:self.bills, parties:self.parties, error: overallError)
                return
            }
            
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
