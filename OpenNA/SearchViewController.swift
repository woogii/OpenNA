//
//  SearchViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 4. 5..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var lawmakers = [Lawmaker]()
    var bills = [Bill]()
    var party = [Party]()
    
    let cellIdentifier = "searchResult"
    
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
        TPPClient.sharedInstance().searchPeople(searchBar.text!, completionHandler:  { results, error in
            
            if let resultArray = results as? [[String:AnyObject]] {
                //print("lawmaker search")
                //print(resultArray)
            } else {
                print(error)
            }
            
        })
        
        
        TPPClient.sharedInstance().searchBills(searchBar.text!, completionHandler:  { bills, error in
            
            if let bills = bills {
                //print("bill search")
                //print(bills)
                self.bills = bills
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                print(error)
            }
            
        })
        
        
        TPPClient.sharedInstance().searchParties(searchBar.text!, completionHandler:  { parties, error in
            
            if let parties = parties {
                //print("party search")
                //print(parties)
            } else {
                print(error)
            }
        })
        
        
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
        
    
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("bill count :\(bills.count)")
        return bills.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel!.text = bills[indexPath.row].name
        return cell
    }
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3
//    }
    
    

}