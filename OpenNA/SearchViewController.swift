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
import Alamofire

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    
    let search = Search()
    var searchResults = [(String, [AnyObject])]()

    var searchResults2 = [[String:AnyObject]]()
    var keySet = [Constants.SectionName.Lawmaker, Constants.SectionName.Bill, Constants.SectionName.Party]
    // var searchResults2 = NSMutableDictionary()
    
    var numOfSection = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register Nib Objects
        tableView.registerNib(UINib(nibName: Constants.Identifier.SearchedLawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedLawmakerCell)
        tableView.registerNib(UINib(nibName: Constants.Identifier.SearchedBillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedBillCell)
        tableView.registerNib(UINib(nibName: Constants.Identifier.SearchedPartyCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedPartyCell)

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
        print("Search bar button tapped")
        
        tableView.reloadData()
        
        search.searchAll(searchBar.text!) { (lawmakers,bills,parties, errorString) in
            
            log.debug("number of lawmaker : \(lawmakers.count)")
            log.debug("number of bill     : \(bills.count)")
            log.debug("number of party    : \(parties.count)")
            
            if lawmakers.count > 0 || bills.count > 0 || parties.count > 0 {
                
                if lawmakers.count > 0 {
                    log.debug("lawmaker count is larger than 0")
                    self.searchResults.append((Constants.SectionName.Lawmaker, lawmakers))
                    self.numOfSection = self.numOfSection + 1
                    // self.searchResults2.setValue(lawmakers, forKey: Constants.SectionName.Lawmaker)
                    
                    
                }
                
                if bills.count > 0 {
                    log.debug("bill count is larger than 0")
                    // self.searchResults.append((Constants.SectionName.Bill, bills))
                    self.searchResults2.append([Constants.SectionName.Lawmaker : bills])
                    // self.searchResults2.setValue(bills, forKey: Constants.SectionName.Bill)
                    self.numOfSection = self.numOfSection + 1
                }
                
                if parties.count > 0 {
                    log.debug("party count is larger than 0")
                    self.searchResults2.append([Constants.SectionName.Lawmaker : parties])
                    // self.searchResults2.setValue(parties, forKey: Constants.SectionName.Party)
                    self.numOfSection = self.numOfSection + 1
                }
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                spinActivity.hide(true)
                self.tableView.reloadData()
            }
        }
        
        searchBar.resignFirstResponder()
    }
    
    
}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
//        if searchResults.count > 0 {
//            
//            if searchResults2[section] == "lawmaker" {
//                
//                if let lawmaker = searchResults[section].1 as? [Lawmaker] {
//                    return lawmaker.count
//                }
//            } else if searchResults[section].0 == "bill" {
//                
//                if let bill = searchResults[section].1 as? [Bill] {
//                    return bill.count
//                }
//                
//            } else {
//                
//                if let party = searchResults[section].1 as? [Party] {
//                    return party.count
//                }
//            }
//        }
        
//            if searchResults2.count > 0 {
//        
//                if searchResults2[section] [Lawmaker] {
//        
//                    if let lawmaker = searchResults[section].1 as? [Lawmaker] {
//                            return lawmaker.count
//                        }
//                } else if searchResults[section].0 == "bill" {
//        
//                    if let bill = searchResults[section].1 as? [Bill] {
//                        return bill.count
//                    }
//        
//                } else {
//        
//                    if let party = searchResults[section].1 as? [Party] {
//                        return party.count
//                    }
//                }
//            }
        
        // return searchResults[section].1.count
        
        print("row count : \(searchResults2[section].count)")
        return searchResults2[section]["lawmaker"]!.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("section in table : \(searchResults2.count)")
        return searchResults2.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //return searchResults.count > 0 ? searchResults[section].0  :  ""
        
        // let keys = searchResults2[section].keys
        // let arrayKeys = Array(keys.map{return String($0)})
        let key = [String](searchResults2[section].keys)
        return searchResults2.count > 0 ? key[0] : "" //searchResults2[section].keys : ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var lawmakerImageRequest : Request?
        var partyImageRequest : Request?
        
        if searchResults2.count > 0 {
            
            let key = [String](searchResults2[indexPath.section].keys)

            // if searchResults2[indexPath.section].0 == "lawmaker" {
            if key[0] == "lawmaker" {
        
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedLawmakerCell, forIndexPath: indexPath) as! SearchedLawmakerTableViewCell
                
                cell.lawmakerImageView!.image = nil
                lawmakerImageRequest?.cancel()
                
                //if let lawmaker = searchResults[indexPath.section].1 as? [Lawmaker] {
                if let lawmaker = searchResults2[indexPath.section][Constants.SectionName.Lawmaker] as? [Lawmaker] {
                    
                    cell.nameLabel?.text = lawmaker[indexPath.row].name
                    
                    guard let urlString = lawmaker[indexPath.row].image else {
                        cell.lawmakerImageView!.image = UIImage(named:"noImage")
                        return cell
                    }
                    
                    if let image = TPPClient.sharedInstance().cachedImage(urlString) {
                        cell.lawmakerImageView!.image = image
                        return cell
                    }
                    print(urlString)
                    
                    lawmakerImageRequest = TPPClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            cell.lawmakerImageView?.image = image
                        }
                    }
                    // cell.taskToCancelifCellIsReused = task
                }

                
            // } else if searchResults[indexPath.section].0 == "bill" {
            } else if key[0] == "bill" {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedBillCell, forIndexPath: indexPath) as! SearchedBillTableViewCell
                

                //if let bill = searchResults[indexPath.section].1 as? [Bill] {
                if let bill = searchResults2[indexPath.section][Constants.SectionName.Bill] as? [Bill] {
                    cell.nameLabel?.text = bill[indexPath.row].name
                    cell.sponsorLabel?.text = bill[indexPath.row].sponsor
                }
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedPartyCell, forIndexPath: indexPath) as! SearchedPartyTableViewCell
                cell.partyImageView!.image = nil
                partyImageRequest?.cancel()
                
                // if let party = searchResults[indexPath.section].1 as? [Party] {
                if let party = searchResults2[indexPath.section][Constants.SectionName.Party] as? [Party] {
                    
                    cell.partyLabel?.text = party[indexPath.row].name
                    
                    guard let urlString = party[indexPath.row].logo else {
                        cell.partyImageView!.image = UIImage(named:"noImage")
                        return cell
                    }
                    print(urlString)
                    if let image = TPPClient.sharedInstance().cachedImage(urlString) {
                        cell.partyImageView!.image = image
                        return cell
                    }
                    
                    partyImageRequest = TPPClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            cell.partyImageView?.image = image
                        }
                    }
                }
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    // MARK : UITableView Delegate Method
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90

    }
}


extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[self.startIndex.advancedBy(i)]
        }
    }
}
