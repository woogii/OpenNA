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
    var searchResults = [SearchResult]()
    
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
        
                
        search.searchAll(searchBar.text!) { (resultss, errorString) in
            
        }
    
        resultsTableView.reloadData()
        searchBar.resignFirstResponder()
    }
        
    
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        switch(section) {
//            case 0:
//                return lawmakers.count
//            case 1:
//                return bills.count
//            default:
//                return parties.count
//        }
        return 0
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
        
//        switch(indexPath.section) {
//            case 0:
//                cell.textLabel?.text = lawmakers[indexPath.row].name
//                return cell
//            case 1:
//                cell.textLabel?.text = bills[indexPath.row].name
//                return cell
//            default:
//                cell.textLabel?.text = parties[indexPath.row].name
//                return cell
//        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    

}