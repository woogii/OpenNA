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

struct SearchResult {
    
    var resultDict = [String:AnyObject]()
    
    // var title:String?
    // var item:[AnyObject]?
    
    init(title: String, item:[AnyObject]) {
        resultDict[title] = item
    }
    
//    init(title: String, item:[AnyObject]) {
//        self.title = title
//        self.item  = item
//    }
}

class Search : NSObject {
    
    var lawmakers = [Lawmaker]()
    var bills = [Bill]()
    var parties = [Party]()
    
    // var searchResults: SearchResult?
    
    var searchResult = [String:AnyObject]()
    
    // var searchedLawmakers: SearchResult?
    // var searchedBills:SearchResult?
    // var searchedParties: SearchResult?
    
    var lawmakerSearchTask: NSURLSessionTask?
    var billSearchTask: NSURLSessionTask?
    var partySearchTask: NSURLSessionTask?

  
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext.init(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
    func searchAll(searchKeyword:String, completionHandler: (results:[String:AnyObject]?, error:NSError?)->Void) {
        
        lawmakerSearchTask?.cancel()
        partySearchTask?.cancel()
        billSearchTask?.cancel()

        let queue = dispatch_queue_create("com.wook2.OpenNA.queue", DISPATCH_QUEUE_CONCURRENT)
        
        dispatch_async(queue) {
            
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
            })
        }
    
        dispatch_async(queue) {
            
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
            })
        }
        
        dispatch_async(queue) {
            
            self.partySearchTask = TPPClient.sharedInstance().searchParties(searchKeyword, completionHandler:  { parties, error in
            
                if let parties = parties {
                    self.parties = parties
                
                    #if DEBUG
                        print("party count: \(parties.count)")
                    #endif
                } else {
                    log.debug(error?.localizedDescription)
                }
            })
        }
        
        dispatch_barrier_sync(queue) {
            
            log.debug("dispatch_barrier")
            if self.lawmakers.count > 0 {
                
                // self.searchedLawmakers = SearchResult(title: "lawmaker", item: self.lawmakers)
                // self.searchResults.append(self.searchedLawmakers!)
                self.searchResult["lawmaker"] = self.lawmakers
            }
            
            if self.bills.count > 0 {
                // self.searchedBills  = SearchResult(title:"bill", item: self.bills)
                // self.searchResults.append(self.searchedBills!)
                // self.searchedBills  = SearchResult(title:"bill", item: self.bills)
                self.searchResult["bill"] = self.bills
            }
            
            if self.parties.count > 0 {
                // self.searchedParties   = SearchResult(title:"party", item: self.parties)
                // self.searchResults.append(self.searchedParties!)
                // self.searchedBills  = SearchResult(title:"bill", item: self.bills)
                self.searchResult["party"] = self.parties
            }
            
            if !self.searchResult.isEmpty {
                print(self.searchResult)
                completionHandler(results: self.searchResult, error:nil)
            }
            else {
                #if DEBUG
                    log.debug("empty")
                #endif
                completionHandler(results:nil, error: NSError(domain: "Search All", code: 0, userInfo: [NSLocalizedDescriptionKey:"There is no search results"]))
            }

        }
        
        
    }
    
}
