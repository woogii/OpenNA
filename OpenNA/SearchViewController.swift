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
   
       
    let cellIdentifier = "searchResult"
    let search = Search()
    // var searchResults = [SearchResult]()
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
        
        print("searchBar text: \(searchBar.text)")
        
                
        search.searchAll(searchBar.text!) { (results, errorString) in
            
            if let results = results {
                print(results)
                self.searchResults = results
                
                dispatch_async(dispatch_get_main_queue()) {
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
                return (searchResults["lawmaker"] as! [Lawmaker]).count
            case 1:
                return (searchResults["bill"] as! [Bill]).count
            default:
                return (searchResults["party"] as! [Party]).count
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
        //return searchResults[section].title
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // cell.textLabel?.text = searchResults[indexPath.section].item![indexPath.row].name
        
        switch(indexPath.section) {
            case 0:
                cell.textLabel?.text = (searchResults["lawmaker"] as! [Lawmaker])[indexPath.row].name
                return cell
            case 1:
                cell.textLabel?.text = (searchResults["bill"] as! [Bill])[indexPath.row].name
                return cell
            default:
                cell.textLabel?.text = (searchResults["party"] as! [Party])[indexPath.row].name
                return cell
        }
        
        //return cell
    }
    

    

}