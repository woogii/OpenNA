//
//  ViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 2. 16..
//  Copyright © 2016년 wook2. All rights reserved.
//
import UIKit
import Foundation
import CoreData
import MBProgressHUD
import AlamofireImage
import Alamofire

// MARK: - PoliticsViewController : UIViewController

class PoliticsViewController: UIViewController  {
  
  // MARK : - Property
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  typealias Entry = (Character, [Lawmaker])
  var lawmakers = [Lawmaker]()
  var bills     = [Bill]()
  var parties   = [Party]()
  var indexInfo = [Entry]()
  var loadingData = false
  var lastRowIndex = 20
  var isRequesting = false
  var isLastPage = false
  static var page = 1
  let cellHeight:CGFloat = 140
  let numberOfRowsForPartyCollectionView:CGFloat = 3
  let valueForAdjustPartyCellHeight:CGFloat = 15
  
  
  // MARK : - CoreData Convenience
  
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  // MARK : - View Life Cycle
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    configureLayout()
    fetchAllLawmakers()
    buildTableViewIndex()
    
  }
  
  // MARK : - Configure Layout
  
  fileprivate func configureLayout() {
    registerNibFilesForTableView()
    setPartyCollectionViewHiddenStatus(hiddenStatus:true)
  }
  
  fileprivate func registerNibFilesForTableView() {
    tableView.register(UINib(nibName: Constants.Identifier.LawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.LawmakerCell)
    tableView.register(UINib(nibName: Constants.Identifier.BillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.BillCell)
  }
  
  fileprivate func setPartyCollectionViewHiddenStatus(hiddenStatus:Bool) {
    collectionView.isHidden = hiddenStatus
  }
  
  // MARK : - Data Fetch
  
  fileprivate func fetchAllLawmakers()
  {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.Lawmaker)
    let sectionSortDescriptor = NSSortDescriptor(key:Constants.Fetch.SortKeyForLawmaker, ascending: true)
    let sortDescriptors = [sectionSortDescriptor]
    fetchRequest.sortDescriptors = sortDescriptors
    
    do {
      self.lawmakers = try sharedContext.fetch(fetchRequest) as! [Lawmaker]
      
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
      self.lawmakers = [Lawmaker]()
    }
  }
  
  override func viewDidLayoutSubviews() {
    
    super.viewDidLayoutSubviews()
    configureCollectionViewFlowlayout()
  }
  
  func configureCollectionViewFlowlayout() {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collectionView.collectionViewLayout = layout
  }
  
  // MARK : - Action Method
  
  @IBAction func segmentedControlChanged(_ sender: AnyObject) {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case SegmentedControlType.lawmaker.rawValue:
      tableView.setContentOffset(CGPoint.zero, animated: true)
      tableView.isHidden = false
      tableView.reloadData()
      break
      
    case SegmentedControlType.bill.rawValue:
      
      tableView.reloadData()
      tableView.setContentOffset(CGPoint.zero, animated: true)
      tableView.isHidden = false
      
      let spinActivity = MBProgressHUD.showAdded(to: view, animated: true)
      spinActivity.label.text = Constants.ActivityIndicatorText.Loading
      
      RestClient.sharedInstance().getBills(PoliticsViewController.page) { (bills, error) in
        
        if let bills = bills {
          
          self.bills = bills
          
          DispatchQueue.main.async  {
            self.tableView.reloadData()
            spinActivity.hide(animated:true)
          }
          
        } else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
          spinActivity.hide(animated:true)
          
        }
      }
      break
      
    case SegmentedControlType.party.rawValue:
      
      collectionView.isHidden = false
      tableView.isHidden = true
      
      let spinActivity = MBProgressHUD.showAdded(to: view, animated: true)
      spinActivity.label.text = Constants.ActivityIndicatorText.Loading
      
      RestClient.sharedInstance().getParties() { (parties, error) in
        
        if let parties = parties {
          
          self.parties = parties
          
          DispatchQueue.main.async  {
            self.collectionView.reloadData()
            spinActivity.hide(animated:true)
          }
        }
        else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
          spinActivity.hide(animated:true)
        }
      }
      
      break
    default:
      break
    }
  }
  
  // MARK : - Helper Methods
  
  func buildTableViewIndex() {
    
    indexInfo = buildIndex(lawmakers)
  }
  
  func buildIndex(_ lawmakers: [Lawmaker]) -> [Entry] {
    
    #if DEBUG
      // Get the first korean character
      // let letters = lawmakers.map {  (lawmaker) -> Character in
      //    lawmaker.name.hangul[0]
      // }
    #endif
    
    // Create the array that contains the first letter of lawmaker's name
    let letters = lawmakers.map {  (lawmaker) -> Character in
      if let name = lawmaker.name {
        return Character(name.firstUppercaseCharacter())
      } else {
        return Character("")
      }
    }
    
    // Delete if there is a duplicate
    let distictLetters = distinct(letters)
    
    // Create the Entry type Array. Entry type represents (Character, [Lawmaker]) tuple
    return distictLetters.map {   (letter) -> Entry in
      
      return (letter, lawmakers.filter  {  (lawmaker) -> Bool in
        if let name = lawmaker.name {
          return Character(name.firstUppercaseCharacter()) == letter
        } else {
          return false
        }
      })
    }
    
    #if DEBUG
      //return distictLetters.map {   (letter) -> Entry in
      
      //   return (letter, lawmakers.filter  {  (lawmaker) -> Bool in
      //                lawmaker.name.hangul[0] == letter
      //    })
      //}
    #endif
  }
  
  func distinct<T:Equatable>(_ source: [T]) -> [T] {
    
    var unique = [T]()
    
    for item in source {
      
      if !unique.contains(item) {
        unique.append(item)
      }
      
    }
    return unique
  }
  
}

// MARK : - PoliticsViewController : UITableViewDelegate, UITableViewDataSource

extension PoliticsViewController : UITableViewDelegate, UITableViewDataSource {
  
  
  // MARK : - UITableView DataSource Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var count = 0
    
    switch segmentedControl.selectedSegmentIndex {
      
    case SegmentedControlType.lawmaker.rawValue:
      count = indexInfo[section].1.count
      break
    case SegmentedControlType.bill.rawValue :
      count = bills.count
      break
    default:
      break
    }
    
    return count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return segmentedControl.selectedSegmentIndex == 0 ? indexInfo.count : 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return segmentedControl.selectedSegmentIndex == 0 ? String(indexInfo[section].0): nil
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return segmentedControl.selectedSegmentIndex == 0 ? indexInfo.map({String($0.0)}):[String]()
  }
  
  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return index
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if segmentedControl.selectedSegmentIndex == SegmentedControlType.lawmaker.rawValue {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.LawmakerCell, for: indexPath) as! LawmakerTableViewCell
      configureCell(cell, atIndexPath: indexPath)
      return cell
    }
    else if segmentedControl.selectedSegmentIndex == SegmentedControlType.bill.rawValue {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.BillCell, for: indexPath) as! BillTableViewCell
      
      cell.nameLabel.text = bills[indexPath.row].name
      cell.sponsorLabel.text = bills[indexPath.row].sponsor
      cell.statusLabel.text = bills[indexPath.row].status
      
      return cell
    }
    
    return UITableViewCell()
  }
  
  // MARK : - Congifure UITableviewCell
  
  func configureCell(_ cell:LawmakerTableViewCell , atIndexPath indexPath:IndexPath)
  {
    
    cell.nameLabel.text = indexInfo[indexPath.section].1[indexPath.row].name
    cell.partyLabel.text = indexInfo[indexPath.section].1[indexPath.row].party
    let urlString:String? = indexInfo[indexPath.section].1[indexPath.row].image
    let url = URL(string: urlString!)!
    
    /*
     Fetch a lawmaker by using a given imageUrl string to check whether an image is cached
     If an image is not cahced, http request function is invoked to download an image
     */
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.Lawmaker )
    let predicate = NSPredicate(format: Constants.Fetch.PredicateForImage, urlString!)
    fetchRequest.predicate = predicate
    // In order to fetch a single object
    fetchRequest.fetchLimit = 1
    
    var fetchedResults:[Lawmaker]!
    let searchedLawmaker:Lawmaker!
    
    do {
      fetchedResults =  try sharedContext.fetch(fetchRequest) as! [Lawmaker]
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
    }
    // Get a single fetched object
    searchedLawmaker = fetchedResults.first
    
    var pinnedImage:UIImage?
    cell.imageView!.image = nil
    
    if  searchedLawmaker.pinnedImage != nil {
      #if DEBUG
        print("images exist")
      #endif
      pinnedImage = searchedLawmaker.pinnedImage
    }
    else {
      
      let task = RestClient.sharedInstance().taskForGetImage(url) { data, error  in
        
        if let data = data {
          
          let image = UIImage(data : data)
          
          DispatchQueue.main.async {
            
            searchedLawmaker.pinnedImage = image
            
            UIView.transition(with: cell.profileImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
              cell.profileImageView!.image = image
            }, completion: nil)
            
            
          }
        }
      }

      cell.taskToCancelifCellIsReused = task
    }
    
    cell.profileImageView!.image = pinnedImage
    
  }
  
  // MARK : - UITableView Delegate Methods
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case SegmentedControlType.lawmaker.rawValue :
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.LawmakerDetailVC) as! LawmakerDetailViewController
      
      controller.name  = indexInfo[indexPath.section].1[indexPath.row].name
      controller.birth = indexInfo[indexPath.section].1[indexPath.row].birth
      controller.party = indexInfo[indexPath.section].1[indexPath.row].party
      controller.when_elected = indexInfo[indexPath.section].1[indexPath.row].when_elected
      controller.district = indexInfo[indexPath.section].1[indexPath.row].district
      controller.homepage = indexInfo[indexPath.section].1[indexPath.row].homepage
      controller.image = indexInfo[indexPath.section].1[indexPath.row].image
      controller.pinnedImage = indexInfo[indexPath.section].1[indexPath.row].pinnedImage
      controller.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(controller, animated: true)
      
      break
      
    case SegmentedControlType.bill.rawValue :
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.BillDetailVC) as! BillDetailViewController
      
      controller.name = bills[indexPath.row].name
      controller.proposedDate = bills[indexPath.row].proposeDate
      controller.status = bills[indexPath.row].status
      controller.sponsor = bills[indexPath.row].sponsor
      controller.documentUrl = bills[indexPath.row].documentUrl
      controller.summary = bills[indexPath.row].summary
      controller.assemblyID = bills[indexPath.row].assemblyId
      
      controller.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(controller, animated: true)
      
      break
      
    default:
      break
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

// MARK: - PoliticsViewController: UICollectionDelegate, UICollectionViewDataSource

extension PoliticsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
  
  // MARK : - UICollectionViewDataSource Methods
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return parties.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.PartyImageCell, for: indexPath) as! PartyCollectionViewCell
    
    configureCollectionViewCell(cell: cell, indexPath: indexPath)
    
    return cell
  }
  
  func configureCollectionViewCell(cell:PartyCollectionViewCell, indexPath:IndexPath) {
    
    let urlString =  Constants.Strings.Party.partyImageUrl + String(parties[indexPath.row].id) + Constants.Strings.Party.partyImageExtension
    
    _ = RestClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
      
      if let image = image {
        DispatchQueue.main.async {
          self.parties[indexPath.row].thumbnail = image
          cell.logoImageView?.image = image
          cell.partyNameLabel.isHidden = true
        }
      } else {
        
        DispatchQueue.main.async {
          let defaultImage = UIImage(named:Constants.Strings.PoliticsVC.PartyPlaceholder)
          cell.logoImageView.image = defaultImage
          cell.partyNameLabel.text = self.parties[indexPath.row].name
          cell.partyNameLabel.isHidden = false
        }
      }
    }
  }
  
  // MARK : - UICollectionViewDelegate Methods
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.WebViewVC) as! WebViewController
    
    controller.urlString = Constants.Strings.SearchVC.WikiUrl + parties[indexPath.row].name
    controller.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(controller, animated: true)
    
  }
}

// MARK : - PoliticsViewController : UICollectionViewDelegateFlowLayout

extension PoliticsViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = floor(self.collectionView.frame.size.width/numberOfRowsForPartyCollectionView)
    return CGSize(width: width, height: width - valueForAdjustPartyCellHeight)
  }
}


// MARK : - PoliticsViewController : UIScrollViewDelegate

extension PoliticsViewController : UIScrollViewDelegate {
  
  // MARK: - UIScrollViewDelegate
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    // check whether scroll is available
    if scrollView.contentSize.height > scrollView.frame.size.height {
      
      // if scroll point is at the end of the screen
      if scrollView.bounds.origin.y + scrollView.frame.size.height >= scrollView.contentSize.height {
      
        if !isRequesting && !isLastPage {
          
          isRequesting = true
          loadBills()
        }
        
      }
    }
  }
  
  func loadBills() {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case SegmentedControlType.bill.rawValue:
      
      let spinActivity = MBProgressHUD.showAdded(to: view, animated: true)
      spinActivity.label.text = Constants.ActivityIndicatorText.Loading
      
      RestClient.sharedInstance().getBills(PoliticsViewController.page) { (bills, error) in
        
        spinActivity.hide(animated:true)
        
        if let addedbills = bills {
          
          if addedbills.count == 0 {
            self.isLastPage = true
            return
          }
          self.bills.append(contentsOf: addedbills)
          self.isRequesting = false
          
          DispatchQueue.main.async  {
            self.tableView.reloadData()
            
          }
        }
        else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
        }
      }
    
    default:
      break
      
    }
    
  }
}



