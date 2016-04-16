//
//  SearchResult.swift
//  OpenNA
//
//  Created by Hyun on 2016. 4. 16..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import CoreData

struct SearchResult {
    
    var title:String?
    var item:[AnyObject]?
    
    init(title: String, item:[AnyObject]) {
        self.title = title
        self.item  = item
    }
}


class Search : NSObject {
    
    var lawmakers = [Lawmaker]()
    var bills = [Bill]()
    var parties = [Party]()
    var searchResults = [SearchResult]()
    var searchedLawmakers: SearchResult?
    var searchedBills:SearchResult?
    var searchedParties: SearchResult?
    
    var lawmakerSearchTask: NSURLSessionDataTask?
    var billSearchTask: NSURLSessionDataTask?
    var partySearchTask: NSURLSessionDataTask?

  
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext.init(concurrencyType: .MainQueueConcurrencyType)
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
    func searchAll(searchKeyword:String, completionHandler: (results:[SearchResult]?, error:NSError?)->Void) {
        
        lawmakerSearchTask?.cancel()
        partySearchTask?.cancel()
        billSearchTask?.cancel()
        

        lawmakerSearchTask = TPPClient.sharedInstance().searchLawmaker(searchKeyword, completionHandler:  { results, error in
            
            if let lawmakerDict = results {
                self.lawmakers = lawmakerDict.map() {
                    Lawmaker(dictionary: $0, context: self.scratchContext)
                }
            }
        })
        
        
        billSearchTask = TPPClient.sharedInstance().searchBills(searchKeyword, completionHandler:  { bills, error in
            
            if let bills = bills {
                
                print(bills)
                self.bills = bills
                
            } else {
                print(error)
            }
            
        })
        
        partySearchTask = TPPClient.sharedInstance().searchParties(searchKeyword, completionHandler:  { parties, error in
            
            if let parties = parties {
                self.parties = parties
                print(parties)
                
            } else {
                print(error)
            }
        })
        
        if lawmakers.count > 0 {
            searchedLawmakers = SearchResult(title: "lawmaker", item: lawmakers)
            searchResults.append(searchedLawmakers!)
        }
        
        if bills.count > 0 {
            searchedBills  = SearchResult(title:"bill", item: bills)
            searchResults.append(searchedBills!)
        }
        
        if parties.count > 0 {
            searchedParties   = SearchResult(title:"party", item: parties)
            searchResults.append(searchedParties!)
        }
    
        if searchResults.isEmpty {
            completionHandler(results:nil, error: NSError(domain: "Search All", code: 0, userInfo: [NSLocalizedDescriptionKey:"There is no search results"]))
        }
        else {
            completionHandler(results: searchResults, error:nil)
        }
    }
    

}
