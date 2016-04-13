//
//  SearchViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 4. 5..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
   
    var lawmakers = [Lawmaker]()
    var bills = [Bill]()
    var parties = [Party]()
    
    let cellIdentifier = "searchResult"
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        print("searchBar text: \(searchBar.text)")
        
        lawmakerSearchTask?.cancel()
        partySearchTask?.cancel()
        billSearchTask?.cancel()
        
        lawmakerSearchTask = TPPClient.sharedInstance().searchLawmaker(searchBar.text!, completionHandler:  { results, error in
            
            if let lawmakerDict = results {
                self.lawmakers = lawmakerDict.map() {
                    Lawmaker(dictionary: $0, context: self.scratchContext)
                }
            }
            
            performUIUpdatesOnMain {
                self.resultsTableView.reloadData()
            }

        })

       
        billSearchTask = TPPClient.sharedInstance().searchBills(searchBar.text!, completionHandler:  { bills, error in
            
            if let bills = bills {
                
                print(bills)
                self.bills = bills
                performUIUpdatesOnMain {
                    self.resultsTableView.reloadData()
                }
            } else {
                print(error)
            }
            
        })
        
        
        partySearchTask = TPPClient.sharedInstance().searchParties(searchBar.text!, completionHandler:  { parties, error in
            
            if let parties = parties {
                self.parties = parties
                print(parties)
                performUIUpdatesOnMain {
                    self.resultsTableView.reloadData()
                }
            } else {
                print(error)
            }
        })
        
        
        resultsTableView.reloadData()
        searchBar.resignFirstResponder()
    }
        
    
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
            case 0:
                return lawmakers.count
            case 1:
                return bills.count
            default:
                return parties.count
        }

    }
   
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionName:String?
        
        switch(section) {
            case 0:
                sectionName = "lawmaker"
                break
            case 1:
                sectionName = "bill"
                break
            default:
                sectionName = "party"
                break
        }
        
        return sectionName
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        switch(indexPath.section) {
            case 0:
                cell.textLabel?.text = lawmakers[indexPath.row].name
                return cell
            case 1:
                cell.textLabel?.text = bills[indexPath.row].name
                return cell
            default:
                cell.textLabel?.text = parties[indexPath.row].name
                return cell
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    

}