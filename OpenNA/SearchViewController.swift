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
    
    var searchedLawmakers = [Lawmaker]()
    var searchedBills     = [Bill]()
    var searchedParties   = [Party]()
    
    var numOfSection = 0
    
    var searchResults:NSMutableArray = [[Lawmaker](),[Bill](),[Party]()]

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
        
        search.searchAll(searchBar.text!) { (lawmakers,bills,parties, errorString) in
            
            self.searchedLawmakers = lawmakers
            self.searchedBills     = bills
            self.searchedParties   = parties
            
            self.searchResults.addObject(lawmakers)
            self.searchResults.addObject(bills)
            self.searchResults.addObject(parties)
            
            log.debug("\(self.searchedLawmakers.count)")
            log.debug("\(self.searchedBills.count)")
            log.debug("\(self.searchedParties.count)")
            
            if lawmakers.count > 0 {
                self.numOfSection = self.numOfSection + 1
            }

            if bills.count > 0 {
                self.numOfSection = self.numOfSection + 1
            }
            
            if parties.count > 0 {
                self.numOfSection = self.numOfSection + 1
            }

            #if DEBUG
                log.debug("\(self.numOfSection)")
                log.debug("search complete")
            #endif
                
                
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
//        log.debug("numberOfRowsInsection")
//        switch(section) {
//        
//        case 0:
//            log.debug("First section")
////            if searchedLawmakers.count > 0 {
////                return searchedLawmakers.count
////            }
//            return searchedLawmakers.count
//        case 1:
//            log.debug("Second section")
////            if searchedBills.count > 0 {
////                return searchedBills.count
////            }
//            return searchedBills.count
//        default:
//            log.debug("Third section")
////            if searchedParties.count > 0 {
////                return searchedParties.count
////            }
//            return searchedParties.count
//        }
        log.debug("\(searchResults[section].count)")
        return searchResults[section].count
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        log.debug("\(numOfSection)")
        return numOfSection
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionName:String?
        
        switch(section) {
        
        case 0:
            if searchedLawmakers.count > 0 {
                sectionName = Constants.SectionName.Lawmaker
            }
            break
        case 1:
            if searchedBills.count > 0 {
                sectionName = Constants.SectionName.Bill
            }
            break
        default:
            if searchedParties.count > 0 {
                sectionName = Constants.SectionName.Party
            }
            break
        }
        
        return sectionName
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        log.debug("cellForRowAtIndexPath")
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchResult, forIndexPath: indexPath)
        
        // cell.textLabel?.text = searchResults[indexPath.section].item![indexPath.row].name
        
        switch(indexPath.section) {
            
        case 0:
             if searchedLawmakers.count > 0 {
                cell.textLabel?.text = searchedLawmakers[indexPath.row].name
                return cell
            }
        case 1:
            if searchedBills.count > 0 {
                cell.textLabel?.text = searchedBills[indexPath.row].name
                return cell
            }
        default:
            if searchedParties.count > 0 {
                cell.textLabel?.text = searchedParties[indexPath.row].name 
                return cell
            }
        }
        
        return cell
    }
    

    

}