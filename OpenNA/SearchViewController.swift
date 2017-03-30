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
  var isSearch: Bool = false
  let rowHeight: CGFloat = 100
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    registerNibFiles()
    setAutoSizeHeightOptions()
    addGestureRecongnizer()
    setTableViewBackground()
    setKeyboardToolBar()
  }
  
  func setKeyboardToolBar() {
    
    let keyboardToolbar = UIToolbar()
    keyboardToolbar.tintColor = UIColor.black
    keyboardToolbar.sizeToFit()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,target: nil, action: nil)
    let doneBarButton = UIBarButtonItem(title: Constants.Title.Button.Dismiss, style: .plain, target: view, action: #selector(UIView.endEditing(_:)))
    keyboardToolbar.items = [flexBarButton, doneBarButton]
    searchBar.inputAccessoryView = keyboardToolbar
    
  }

  func registerNibFiles() {
    
    tableView.register(UINib(nibName: Constants.Identifier.SearchedLawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedLawmakerCell)
    tableView.register(UINib(nibName: Constants.Identifier.SearchedBillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedBillCell)
    tableView.register(UINib(nibName: Constants.Identifier.SearchedPartyCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.SearchedPartyCell)
    
  }
  
  func setTableViewBackground() {
    
    let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
    noDataLabel.text = Constants.Strings.SearchVC.DefaultLabelMessage
    noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
    noDataLabel.textAlignment = NSTextAlignment.center
    
    self.tableView.backgroundView = noDataLabel
    self.tableView.separatorStyle = .none
    
  }
  
  func setAutoSizeHeightOptions() {
    tableView.estimatedRowHeight = rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  func addGestureRecongnizer() {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    tableView.addGestureRecognizer(gestureRecognizer)
    gestureRecognizer.cancelsTouchesInView = false
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchBar.becomeFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.isNavigationBarHidden = false
  }
  
  // MARK : - Hide Keyboard
  
  func hideKeyboard() {
    view.endEditing(true)
  }
  
}

// MARK : - SearchViewController : UISearchBarDelegate

extension SearchViewController : UISearchBarDelegate {
  
  // MARK : - UISearchBarDelegate Method
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    isSearch = true
    
    let spinActivity = MBProgressHUD.showAdded(to: view, animated: true)
    spinActivity.label.text = Constants.ActivityIndicatorText.Searching
    
    searchResults = []
    sectionTitle = []
    
    
    search.searchAll(searchBar.text!) { (lawmakers,bills,parties, error) in
      
      if let error = error {
        CommonHelper.showAlertWithMsg(self, msg: error.localizedDescription, showCancelButton: false,
                                      okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
        spinActivity.hide(animated:true)
        return
      }
      
      if lawmakers.count > 0 {
        
        self.searchResults.append([Constants.SectionName.Lawmaker:lawmakers as AnyObject])
        self.sectionTitle.append(Constants.SectionName.Lawmaker)
        
      }
      
      if bills.count > 0 {
        
        self.searchResults.append([Constants.SectionName.Bill: bills as AnyObject])
        self.sectionTitle.append(Constants.SectionName.Bill)
      }
      
      if parties.count > 0 {
        
        self.searchResults.append([Constants.SectionName.Party : parties as AnyObject])
        self.sectionTitle.append(Constants.SectionName.Party)
        
      }
      
      DispatchQueue.main.async {
        spinActivity.hide(animated:true)
        self.tableView.reloadData()
      }
    }
    
    tableView.reloadData()
    searchBar.resignFirstResponder()
  }
  
  // MARK : - Adjust Bar position
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
  
}

// MARK : - SearchViewController : UITableViewDataSource, UITableViewDelegate

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {
  
  // MARK : UITableViewDataSource Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    guard let section = searchResults[section][sectionTitle[section]] else {
      return 0
    }
    
    return section.count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    var numberOfSection = 0
    
    if searchResults.count > 0 {
      
      self.tableView.backgroundView = nil
      numberOfSection = searchResults.count
      
    } else {
      
      let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
      (isSearch == true) ? (noDataLabel.text = Constants.Strings.SearchVC.NoSearchResultMessage) : (noDataLabel.text = Constants.Strings.SearchVC.DefaultLabelMessage)
      noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
      noDataLabel.textAlignment = NSTextAlignment.center
      self.tableView.backgroundView = noDataLabel
      self.tableView.separatorStyle = .none
      
    }
    
    return numberOfSection
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sectionTitle[section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    var lawmakerImageRequest : Request?
    var partyImageRequest : Request?
    
    if searchResults.count > 0 {
      tableView.separatorStyle = .singleLine
      let section = sectionTitle[indexPath.section]
      
      if section == Constants.SectionName.Lawmaker {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerCell, for: indexPath) as! SearchedLawmakerTableViewCell
        
        cell.lawmakerImageView!.image = nil
        lawmakerImageRequest?.cancel()
        
        if let lawmaker = searchResults[indexPath.section][Constants.SectionName.Lawmaker] as? [Lawmaker] {
          
          cell.nameLabel?.text = lawmaker[indexPath.row].name
          
          guard let urlString = lawmaker[indexPath.row].image else {
            cell.lawmakerImageView!.image = UIImage(named:Constants.Strings.SearchVC.defaultImageName)
            return cell
          }
          
          lawmakerImageRequest = RestClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
            
            if let image = image {
              
              DispatchQueue.main.async {
                cell.lawmakerImageView?.image = image
              }
            } else {
              
              CommonHelper.showAlertWithMsg(self, msg: error!.localizedDescription, showCancelButton: false,
                                            okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
            }
          }
          
          return cell
        }
        
      } else if section == Constants.SectionName.Bill {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedBillCell, for: indexPath) as! SearchedBillTableViewCell
        if let bill = searchResults[indexPath.section][Constants.SectionName.Bill] as? [Bill] {
          cell.nameLabel?.text = bill[indexPath.row].name
          cell.sponsorLabel?.text = bill[indexPath.row].sponsor
        }
        
        return cell
        
      } else {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedPartyCell, for: indexPath) as! SearchedPartyTableViewCell
        cell.partyImageView!.image = nil
        partyImageRequest?.cancel()
        
        if let party = searchResults[indexPath.section][Constants.SectionName.Party] as? [Party] {
          
          cell.partyLabel?.text = party[indexPath.row].name
          
          guard let urlString = party[indexPath.row].logo else {
            return cell
          }
          
          if party[indexPath.row].logo == ""  {
            
            cell.partyImageView!.image = UIImage(named:Constants.Strings.SearchVC.PartyPlaceholder)
            return cell
          }
          
          partyImageRequest = RestClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
            
            if let image = image {
              DispatchQueue.main.async {
                cell.partyImageView?.image = image
              }
            } else {
              CommonHelper.showAlertWithMsg(self, msg: error!.localizedDescription, showCancelButton: false,
                                            okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
            }
            
          }
        }
        return cell
      }
    }
    
    return UITableViewCell()
  }
  
  // MARK : UITableView Delegate Methods
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    if sectionTitle[indexPath.section] == Constants.SectionName.Lawmaker {
      
      guard let lawmakers = searchResults[indexPath.section][Constants.SectionName.Lawmaker] as? [Lawmaker] else {
        return
      }
      
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.SearchedLawmakerDetailVC) as! SearchedLawmakerDetailViewController
      
      #if DEBUG
        print("\(lawmakers[indexPath.row].name)")
        print("\(lawmakers[indexPath.row].birth)")
        print("\(lawmakers[indexPath.row].party)")
      #endif
      
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
      
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.BillDetailVC) as! BillDetailViewController
      
      controller.bill = bills[indexPath.row]      
      controller.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(controller, animated: true)
      
    } else {
      
      guard let party = searchResults[indexPath.section][Constants.SectionName.Party] as? [Party] else {
        return
      }
      
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.WebViewVC) as! WebViewController
      controller.urlString = Constants.Strings.SearchVC.WikiUrl + party[indexPath.row].name
      
      controller.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(controller, animated: true)
    }
    
  }
  
}
