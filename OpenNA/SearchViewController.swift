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

// MARK : - SearchViewController : UIViewController

class SearchViewController: UIViewController {
    
    // MARK : - Property 
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let search = Search()
    var searchResults = [[String:AnyObject]]()
    var sectionTitle = [String]()
    
    // MARK : - View Life Cycle 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  navigationController?.navigationBarHidden = true
        // Register Nib Objects
        tableView.registerNib(UINib(nibName: Constants.Identifier.SearchedLawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedLawmakerCell)
        tableView.registerNib(UINib(nibName: Constants.Identifier.SearchedBillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedBillCell)
        tableView.registerNib(UINib(nibName: Constants.Identifier.SearchedPartyCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedPartyCell)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tableView.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false 
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    
    // MARK : - Hide Keyboard
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK : - Prepare For Segue 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Identifier.SearchedLawmakerDetailVC {
            
            
            
        }
    }
    
}

// MARK : - SearchViewController : UISearchBarDelegate

extension SearchViewController : UISearchBarDelegate {
    
    // MARK : - UISearchBarDelegate Method
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        let spinActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
        spinActivity.labelText = Constants.ActivityIndicatorText.Searching
        
        searchResults = []
        sectionTitle = []
        
        search.searchAll(searchBar.text!) { (lawmakers,bills,parties, errorString) in
            
            log.debug("number of lawmaker : \(lawmakers.count)")
            log.debug("number of bill     : \(bills.count)")
            log.debug("number of party    : \(parties.count)")
            log.debug("\(lawmakers)")
            if lawmakers.count > 0 {
                    
                self.searchResults.append([Constants.SectionName.Lawmaker:lawmakers])
                self.sectionTitle.append(Constants.SectionName.Lawmaker)
            
            }
                
            if bills.count > 0 {
                    
                self.searchResults.append([Constants.SectionName.Bill: bills])
                self.sectionTitle.append(Constants.SectionName.Bill)
            }
                
            if parties.count > 0 {
                
                self.searchResults.append([Constants.SectionName.Party : parties])
                self.sectionTitle.append(Constants.SectionName.Party)
            
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                spinActivity.hide(true)
                self.tableView.reloadData()
            }
        }
        
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    // MARK : - Adjust Bar position
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }

}

// MARK : - SearchViewController : UITableViewDataSource, UITableViewDelegate

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    // MARK : UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        log.debug("section : \(section)")
        
        guard let section = searchResults[section][sectionTitle[section]] else {
            log.debug("number of rows : 0")
            return 0
        }

        return section.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        log.debug("number of section : \(searchResults.count)")
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        log.debug("section for title  : \(section)")
        
        return sectionTitle[section]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var lawmakerImageRequest : Request?
        var partyImageRequest : Request?
        print("search result : \(searchResults.count)")
        
        if searchResults.count > 0 {
            
            let key = [String](searchResults[indexPath.section].keys)
            print("key : \(key)")
           
            let section = sectionTitle[indexPath.section]

            //if key[0] == "lawmaker" {
            if section == Constants.SectionName.Lawmaker {
        
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedLawmakerCell, forIndexPath: indexPath) as! SearchedLawmakerTableViewCell
                
                cell.lawmakerImageView!.image = nil
                lawmakerImageRequest?.cancel()
                
                if let lawmaker = searchResults[indexPath.section][Constants.SectionName.Lawmaker] as? [Lawmaker] {
                    print(lawmaker[indexPath.row].name)
                    
                    cell.nameLabel?.text = lawmaker[indexPath.row].name
                    
                    guard let urlString = lawmaker[indexPath.row].image else {
                        cell.lawmakerImageView!.image = UIImage(named:Constants.Strings.SearchVC.defaultImageName)
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
                    
                    return cell
                }

            // } else if key[0] == "bill" {
            } else if section == Constants.SectionName.Bill {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedBillCell, forIndexPath: indexPath) as! SearchedBillTableViewCell
                
                if let bill = searchResults[indexPath.section][Constants.SectionName.Bill] as? [Bill] {
                    cell.nameLabel?.text = bill[indexPath.row].name
                    cell.sponsorLabel?.text = bill[indexPath.row].sponsor
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedPartyCell, forIndexPath: indexPath) as! SearchedPartyTableViewCell
                cell.partyImageView!.image = nil
                partyImageRequest?.cancel()
                
                if let party = searchResults[indexPath.section][Constants.SectionName.Party] as? [Party] {
                    
                    cell.partyLabel?.text = party[indexPath.row].name
                    
                    guard let urlString = party[indexPath.row].logo else {
                        return cell
                    }
                    
                    if party[indexPath.row].logo == ""  {
                
                        cell.partyImageView!.image = UIImage(named:Constants.Strings.SearchVC.defaultImageName)
                        return cell
                    }
                    
                    // print(urlString)
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
    
    // MARK : UITableView Delegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if sectionTitle[indexPath.section] == Constants.SectionName.Lawmaker {
            
            guard let lawmakers = searchResults[indexPath.section][Constants.SectionName.Lawmaker] as? [Lawmaker] else {
                return
            }

            let controller = storyboard?.instantiateViewControllerWithIdentifier(Constants.Identifier.SearchedLawmakerDetailVC) as! SearchedLawmakerDetailViewController
        
            log.debug("\(lawmakers[indexPath.row].name)")
            log.debug("\(lawmakers[indexPath.row].birth)")
            log.debug("\(lawmakers[indexPath.row].party)")
            
            controller.name  = lawmakers[indexPath.row].name
            controller.birth = lawmakers[indexPath.row].birth
            controller.address = lawmakers[indexPath.row].address
            controller.blog   = lawmakers[indexPath.row].blog
            controller.education   = lawmakers[indexPath.row].education
            controller.homepage = lawmakers[indexPath.row].homepage
            controller.image = lawmakers[indexPath.row].image
            
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)

        } else if sectionTitle[indexPath.section] == Constants.SectionName.Bill {
        
            guard let bills = searchResults[indexPath.section][Constants.SectionName.Bill] as? [Bill] else {
                return
            }
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier(Constants.Identifier.BillDetailVC) as! BillDetailViewController
            
            controller.name = bills[indexPath.row].name
            controller.proposedDate = bills[indexPath.row].proposeDate
            controller.status = bills[indexPath.row].status
            controller.sponsor = bills[indexPath.row].sponsor
            controller.documentUrl = bills[indexPath.row].documentUrl
            controller.summary = bills[indexPath.row].summary
            controller.assemblyID = bills[indexPath.row].assemblyId
            
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)

        } else {
        
            guard let party = searchResults[indexPath.section][Constants.SectionName.Party] as? [Party] else {
                return
            }
            
            let controller = storyboard?.instantiateViewControllerWithIdentifier(Constants.Identifier.WebViewVC) as! WebViewController
            controller.urlString = Constants.Strings.SearchVC.WikiUrl + party[indexPath.row].name
            
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }

    }
    
}
