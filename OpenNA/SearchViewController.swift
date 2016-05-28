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
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var tableView: UITableView!

    
    let search = Search()
    
    var searchResults = [(String, [AnyObject])]()
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
        
        search.searchAll(searchBar.text!) { (lawmakers,bills,parties, errorString) in
            
            log.debug("number of lawmaker : \(lawmakers.count)")
            log.debug("number of bill     : \(bills.count)")
            log.debug("number of party    : \(parties.count)")
            
            if lawmakers.count > 0 || bills.count > 0 || parties.count > 0 {
                
                if lawmakers.count > 0 {
                    log.debug("lawmaker count is larger than 0")
                    self.searchResults.append((Constants.SectionName.Lawmaker, lawmakers))
                    self.numOfSection = self.numOfSection + 1
                }
                
                if bills.count > 0 {
                    log.debug("bill count is larger than 0")
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
        
        var lawmakerImageRequest : Request?
        var partyImageRequest : Request?
        
        if searchResults.count > 0 {
            
            if searchResults[indexPath.section].0 == "lawmaker" {
        
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedLawmakerCell, forIndexPath: indexPath) as! SearchedLawmakerTableViewCell
                
                cell.lawmakerImageView!.image = nil
                lawmakerImageRequest?.cancel()
                
                if let lawmaker = searchResults[indexPath.section].1 as? [Lawmaker] {
                    
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
                    // let url = NSURL(string: urlString)!
                    
                    lawmakerImageRequest = TPPClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            cell.lawmakerImageView?.image = image
                        }
                    }
                    // cell.taskToCancelifCellIsReused = task
                }

                
            } else if searchResults[indexPath.section].0 == "bill" {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedBillCell, forIndexPath: indexPath) as! SearchedBillTableViewCell
                

                if let bill = searchResults[indexPath.section].1 as? [Bill] {
                    cell.nameLabel?.text = bill[indexPath.row].name
                    cell.sponsorLabel?.text = bill[indexPath.row].sponsor
                    // cell.imageView?.image = nil
                }
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedPartyCell, forIndexPath: indexPath) as! SearchedPartyTableViewCell
                cell.partyImageView!.image = nil
                partyImageRequest?.cancel()
                
                if let party = searchResults[indexPath.section].1 as? [Party] {
                    
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
>>>>>>> f34c88811eca0e4670bd8b153c9b02f599a5b830
    }
}

