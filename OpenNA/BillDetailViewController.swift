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


// MARK: - BillDetailViewController : UITableViewController

class BillDetailViewController: UITableViewController {
  
  // MARK : - Property
  
  @IBOutlet weak var assembylIDLabel: UILabel!
  @IBOutlet weak var proposedDateLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var sponsorLabel: UILabel!
  @IBOutlet weak var documentURLLabel: UILabel!
  @IBOutlet weak var summaryTextView: UITextView!
  
  var proposedDate: String?
  var status : String?
  var sponsor : String?
  var documentUrl : String?
  var summary : String?
  var assemblyID : Int?
  var name : String?
  var favoriteButton: UIBarButtonItem?
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    configureTableViewDynamicHeight()
  }
  
  func configureTableViewDynamicHeight() {
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    setProposedDate()
    setBillStatus()
    setSponsor()
    setBillURL()
    setSummary()
    setAssemblyID()
    configureFavoriteButton()
  }
  
  func setProposedDate() {
    proposedDateLabel.text = proposedDate
  }
  
  func setBillStatus() {
    statusLabel.text = status
  }
  
  func setSponsor() {
    sponsorLabel.text = sponsor
  }
  
  func setBillURL() {
    documentURLLabel.text = documentUrl
  }

  func configureFavoriteButton() {
  
    if previousViewController() != nil {
      
      let fetchedResults = fetchBillInList()
      
      if fetchedResults?.count == 0 {
        createRightBarButtonItem(withImageName: Constants.Images.FavoriteIconEmpty)
      } else {
        createRightBarButtonItem(withImageName: Constants.Images.FavoriteIconFilled)
      }
      
    }
  }
  
  func createRightBarButtonItem(withImageName:String) {
    
    let image = UIImage(named:withImageName)?.withRenderingMode(.alwaysOriginal)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(favoriteButtonTapped))
    navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)

  }
  
  func setSummary() {
    
    if let count = summary?.characters.count {
      
      if count > 0 {
        summaryTextView.text = summary
      } else {
        summaryTextView.text = Constants.Strings.BillDetailVC.TextViewDefaultMsg
      }
    } else {
      summaryTextView.text = Constants.Strings.BillDetailVC.TextViewDefaultMsg
    }
  }
  
  func setAssemblyID() {
    
    guard let assemblyID = assemblyID  else {
      assembylIDLabel.text = ""
      return
    }
    
    assembylIDLabel.text = "\(assemblyID)"

  }
  
  // MARK : - UITableViewDelegate Method
  
  override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.section == 1 {
      return UITableViewAutomaticDimension
    } else {
      return CGFloat(44)
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
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
      
      let _ = BillInList(name: name, proposedDate: proposedDate,sponsor: sponsor, status: status, summary: summary, documentUrl: documentUrl, assemblyID: assemblyID, context: sharedContext)
      
      do {
        try sharedContext.save()
      } catch {
        #if DEBUG
          print("\(error)")
        #endif
      }
      
      createRightBarButtonItem(withImageName: Constants.Images.FavoriteIconFilled)
      
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
      
      createRightBarButtonItem(withImageName: Constants.Images.FavoriteIconEmpty)
    }
    
  }
  
  // MARK : - Prepare Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == Constants.Identifier.segueToWebViewVC {
      let controller = segue.destination as! WebViewController
      controller.urlString = documentUrl
      controller.hidesBottomBarWhenPushed = true
      controller.isFromBillDetailVC = true 
    }
  }
  
  @IBAction func pushBackButton(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
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
