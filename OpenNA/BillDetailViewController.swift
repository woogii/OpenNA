//
//  BillDetailViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 5. 15..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


// MARK: - BillDetailViewController : UITableViewController

class BillDetailViewController: UITableViewController {
  
  // MARK : - Property
  
  @IBOutlet weak var assembylIDLabel: UILabel!
  @IBOutlet weak var proposedDateLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var sponsorLabel: UILabel!
  @IBOutlet weak var documentURLLabel: UILabel!
  @IBOutlet weak var summaryTextView: UITextView!
  @IBOutlet weak var favoriteButton: UIBarButtonItem!
  
  var proposedDate: String?
  var status : String?
  var sponsor : String?
  var documentUrl : String?
  var summary : String?
  var assemblyID : Int?
  var name : String?
  
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    if let row = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: row, animated: false)
    }
    
    proposedDateLabel.text = proposedDate
    statusLabel.text = status
    sponsorLabel.text = sponsor
    documentURLLabel.text = documentUrl
    
    if summary?.characters.count > 0 {
      summaryTextView.text = summary
    } else {
      summaryTextView.text = Constants.Strings.BillDetailVC.TextViewDefaultMsg
    }
    
    guard let assemblyID = assemblyID  else {
      assembylIDLabel.text = ""
      return
    }
    
    if previousViewController() != nil {
      
      if previousViewController() is SearchViewController {
        
        favoriteButton.image = nil
      }
      
    }
    
    assembylIDLabel.text = "\(assemblyID)"
    
    let fetchedResults = fetchBillInList()
    
    fetchedResults!.count == 0 ? (favoriteButton.tintColor = nil) : (favoriteButton.tintColor = UIColor.red)
  }
  
  // MARK : - UITableViewDelegate Method
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.section == 1 {
      return UITableViewAutomaticDimension
    } else {
      return CGFloat(44)
    }
  }
  
  // MARK : - Fetch Bills in MyList
  
  func fetchBillInList()->[BillInList]?{
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.BillInList)
    fetchRequest.predicate = NSPredicate(format: Constants.Fetch.PredicateForName, name!)
    
    // In order to fetch a single object
    fetchRequest.fetchLimit = 1
    
    var fetchedResults : [BillInList]?
    
    do {
      fetchedResults = try sharedContext.fetch(fetchRequest) as? [BillInList]
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
    }
    
    return fetchedResults
  }
  
  // MARK : - Action Method
  
  @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
    
    let fetchedResults = fetchBillInList()
    
    if fetchedResults!.count == 0  {
      
      var dictionary = [String:AnyObject]()
      
      dictionary[Constants.ModelKeys.BillName] = name as AnyObject?
      dictionary[Constants.ModelKeys.BillProposedDate] = proposedDate as AnyObject?
      dictionary[Constants.ModelKeys.BillSponsor] = sponsor as AnyObject?
      dictionary[Constants.ModelKeys.BillStatus] = status as AnyObject?
      dictionary[Constants.ModelKeys.BillSummary] = summary as AnyObject?
      dictionary[Constants.ModelKeys.BillDocumentUrl] = documentUrl as AnyObject?
      dictionary[Constants.ModelKeys.BillAssemblyId] = assemblyID as AnyObject?
      
      let _ = BillInList(dictionary: dictionary, context: sharedContext)
      
      do {
        try sharedContext.save()
      } catch {
        #if DEBUG
          print("\(error)")
        #endif
      }
      
      favoriteButton.tintColor = UIColor.red
      
    } else {
      
      guard let result = fetchedResults!.first else {
        return
      }
      
      sharedContext.delete(result)
      
      do {
        try sharedContext.save()
      } catch {
        #if DEBUG
          print("\(error)")
        #endif
      }
      
      favoriteButton.tintColor = nil
    }
    
  }
  
  // MARK : - Prepare Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == Constants.Identifier.segueToWebViewVC {
      let controller = segue.destination as! WebViewController
      controller.urlString = documentUrl
      controller.hidesBottomBarWhenPushed = true
    }
  }
  
  
}

// MARK : - UIViewController Extension

extension UIViewController {
  
  // MARK : - Get a reference of the previousViewController
  func previousViewController() -> UIViewController? {
    if let stack = self.navigationController?.viewControllers {
      for i in (1..<stack.count).reversed() {
        if(stack[i] == self) {
          return stack[i-1]
        }
      }
    }
    return nil
  }
}
