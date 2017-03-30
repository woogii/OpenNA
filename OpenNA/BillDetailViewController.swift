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
 
  var bill:Bill!
  var favoriteButton: UIBarButtonItem?
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  let rowHeight:CGFloat = 44.0
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setProposedDate()
    setBillStatus()
    setSponsor()
    setBillURL()
    setSummary()
    setAssemblyID()
    configureTableViewDynamicHeight()
  }
  
  func configureTableViewDynamicHeight() {
    tableView.estimatedRowHeight = rowHeight
    tableView.rowHeight = UITableViewAutomaticDimension
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    configureFavoriteButton()
  }
  
  func setProposedDate() {
    proposedDateLabel.text = bill.proposeDate
  }
  
  func setBillStatus() {
    statusLabel.text = bill.status
  }
  
  func setSponsor() {
    sponsorLabel.text = bill.sponsor
  }
  
  func setBillURL() {
    documentURLLabel.text = bill.documentUrl
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
    
    if let count = bill.summary?.characters.count {
      
      if count > 0 {
        summaryTextView.text = bill.summary
      } else {
        summaryTextView.text = Constants.Strings.BillDetailVC.TextViewDefaultMsgKr
      }
    } else {
      summaryTextView.text = Constants.Strings.BillDetailVC.TextViewDefaultMsgKr
    }
  }
  
  func setAssemblyID() {
    
    guard let assemblyID = bill.assemblyId  else {
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
    fetchRequest.predicate = NSPredicate(format: Constants.Fetch.PredicateForName, bill.name!)
    
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
      
      let _ = BillInList(name: bill.name, proposedDate: bill.proposeDate,sponsor: bill.sponsor, status: bill.status, summary: bill.summary, documentUrl: bill.documentUrl, assemblyID: bill.assemblyId, context: sharedContext)
      
      do {
        try sharedContext.save()
      } catch {
        #if DEBUG
          print("\(error)")
        #endif
      }
      
      createRightBarButtonItem(withImageName: Constants.Images.FavoriteIconFilled)
      
    } else {
      
      guard let result = fetchedResults!.first else { return }
      
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
      controller.urlString = bill.documentUrl
      controller.hidesBottomBarWhenPushed = true
      controller.isFromBillDetailVC = true 
    }
  }
  
  @IBAction func pushBackButton(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
  }
  
}

