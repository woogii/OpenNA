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
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var billTableView: UITableView!
  @IBOutlet weak var lawmakerTableView: UITableView!
  
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
  let maximumDisctirctCharCount = 8

  
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
    requestBillInfo()
    requestPartyInfo()
  }
  
  func requestBillInfo() {
  
    RestClient.sharedInstance().getBills(PoliticsViewController.page) { (bills, error) in
      
      if let bills = bills {
        self.bills = bills
        DispatchQueue.main.async  {
          self.billTableView.reloadData()
        }
      
      } else {
        CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                      okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
      }
    }
    
  }
  
  func requestPartyInfo() {
    
    RestClient.sharedInstance().getParties() { (parties, error) in
      
      if let parties = parties {
        
        self.parties = parties
        
        DispatchQueue.main.async  {
          self.collectionView.reloadData()
        }
      }
      else {
        CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                      okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
        
      }
    }

  }
  
  // MARK : - Configure Layout
  
  fileprivate func configureLayout() {
    registerNibFilesForTableView()
    setPartyCollectionViewHiddenStatus(hiddenStatus:true)
  }
  
  fileprivate func registerNibFilesForTableView() {
    lawmakerTableView.register(UINib(nibName: Constants.Identifier.LawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.LawmakerCell)
    billTableView.register(UINib(nibName: Constants.Identifier.BillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.BillCell)
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
      
      lawmakerTableView.isHidden = false
      billTableView.isHidden = true
      break
      
    case SegmentedControlType.bill.rawValue:
      
      billTableView.isHidden = false
      lawmakerTableView.isHidden = true
      break
      
    case SegmentedControlType.party.rawValue:
      
      collectionView.isHidden = false
      lawmakerTableView.isHidden = true
      billTableView.isHidden = true
      
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
    
    // Get the first korean character
    let letters = lawmakers.map {  (lawmaker) -> Character in
      guard let name = lawmaker.name else {
        return Character("")
      }
      return name.hangul[0]
    }
    
    // Delete if there is a duplicate
    let distictLetters = distinct(letters)
    
    return distictLetters.map {   (letter) -> Entry in
      
        return (letter, lawmakers.filter  {  (lawmaker) -> Bool in
          
            guard let name = lawmaker.name else {
              return false
            }
            return name.hangul[0] == letter
        })
    }

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




