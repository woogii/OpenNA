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
    
    var searchResults = [String:AnyObject]()
    
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
        
        search.searchAll(searchBar.text!) { (results, errorString) in
            
            if let results = results {
                
                #if DEBUG
                    log.debug("search complete")
                #endif
                self.searchResults = results
                
                dispatch_async(dispatch_get_main_queue()) {
                    spinActivity.hide(true)
                    self.resultsTableView.reloadData()
                }
            }
        }
        searchBar.resignFirstResponder()
    }
        
    
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(section) {
            case 0:
                return (searchResults[Constants.SectionName.Lawmaker] as! [Lawmaker]).count
            case 1:
                return (searchResults[Constants.SectionName.Bill] as! [Bill]).count
            default:
                return (searchResults[Constants.SectionName.Party] as! [Party]).count
        }
        
        // return searchResults[section].item!.count
    }
   
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var sectionName:String?
        
        switch(section) {
            case 0:
                sectionName = Constants.SectionName.Lawmaker
                break
            case 1:
                sectionName = Constants.SectionName.Bill
                break
            default:
                sectionName = Constants.SectionName.Party
                break
        }
        
        return sectionName
        //return searchResults[section].title
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchResult, forIndexPath: indexPath)
        
        // cell.textLabel?.text = searchResults[indexPath.section].item![indexPath.row].name
        
        switch(indexPath.section) {
            case 0:
                cell.textLabel?.text = (searchResults[Constants.SectionName.Lawmaker] as! [Lawmaker])[indexPath.row].name
                return cell
            case 1:
                cell.textLabel?.text = (searchResults[Constants.SectionName.Bill] as! [Bill])[indexPath.row].name
                return cell
            default:
                cell.textLabel?.text = (searchResults[Constants.SectionName.Party] as! [Party])[indexPath.row].name
                return cell
        }
        
        //return cell
    }
    

    

}