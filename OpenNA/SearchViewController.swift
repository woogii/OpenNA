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
import MBProgressHUD

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTableView: UITableView!
   
    let search = Search()
    
    var searchResults = [(String, [AnyObject])]()
    var numOfSection = 0

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
        
        let spinActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
        spinActivity.labelText = Constants.ActivityIndicatorText.Searching
        
        numOfSection = 0
        searchResults = []
        
        search.searchAll(searchBar.text!) { (lawmakers,bills,parties, errorString) in
            
            log.debug("number of lawmaker : \(lawmakers.count)")
            log.debug("number of bill     : \(bills.count)")
            log.debug("number of party    : \(parties.count)")

            if lawmakers.count > 0 || bills.count > 0 || parties.count > 0 {
                
                if lawmakers.count > 0 {
                    log.debug("lawmaker count is larger than 0")  // 0
                    self.searchResults.append((Constants.SectionName.Lawmaker, lawmakers))
                    self.numOfSection = self.numOfSection + 1
                }
                
                if bills.count > 0 {
                    log.debug("bill count is larger than 0")  // 0
                    self.searchResults.append((Constants.SectionName.Bill, bills))
                    self.numOfSection = self.numOfSection + 1
                }
                
                if parties.count > 0 {
                    log.debug("party count is larger than 0")
                    self.searchResults.append((Constants.SectionName.Party, parties))
                    self.numOfSection = self.numOfSection + 1
                }
            }
    
            dispatch_async(dispatch_get_main_queue()) {
                spinActivity.hide(true)
                self.resultsTableView.reloadData()
            }
        }
        
        searchBar.resignFirstResponder()
    }
        
    
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchResults.count > 0 {
            
            if searchResults[section].0 == "lawmaker" {
            
                if let lawmaker = searchResults[section].1 as? [Lawmaker] {
                        return lawmaker.count
                }
            } else if searchResults[section].0 == "bill" {
            
                if let bill = searchResults[section].1 as? [Bill] {
                    return bill.count
                }
            
            } else {
            
                if let party = searchResults[section].1 as? [Party] {
                    return party.count
                }
            }
        }

        return searchResults.count
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return searchResults.count > 0 ? searchResults[section].0 : ""
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchResult, forIndexPath: indexPath)
        
        if searchResults.count > 0 {
            
            if searchResults[indexPath.section].0 == "lawmaker" {
            
                if let lawmaker = searchResults[indexPath.section].1 as? [Lawmaker] {
                    cell.textLabel?.text = lawmaker[indexPath.row].name
                }
            
            } else if searchResults[indexPath.section].0 == "bill" {
            
                if let bill = searchResults[indexPath.section].1 as? [Bill] {
                    cell.textLabel?.text = bill[indexPath.row].name
                }
            
            } else {
            
                if let party = searchResults[indexPath.section].1 as? [Party] {
                    cell.textLabel?.text = party[indexPath.row].name
                }
            }
        }

        return cell
    }
}
