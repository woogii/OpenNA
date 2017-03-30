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

class BillDetailViewController: UIViewController {
  
  // MARK : - Property
  
  @IBOutlet weak var summaryTextView: UITextView!
  @IBOutlet weak var tableView: UITableView!
 
  var bill:Bill!
  var favoriteButton: UIBarButtonItem?
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  let numberOfBillDetailInfo = 5
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    tableView.reloadData()
    setSummary()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    configureFavoriteButton()
    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    summaryTextView.setContentOffset(CGPoint.zero, animated: false)
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

extension BillDetailViewController : UITableViewDataSource, UITableViewDelegate {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfBillDetailInfo
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.BillDetailInfoTableViewCell, for: indexPath) as! BillDetailInfoTableViewCell
    
    switch(indexPath.row) {
      
      case BillDetailInfoType.assemblyId.rawValue:
      configureBillDetailTableViewCell(cell: cell, title: Constants.Strings.BillDetailVC.AssemblyIdTitle, description: String(bill.assemblyId ?? 0))
      break
      case BillDetailInfoType.proposeDate.rawValue:
      configureBillDetailTableViewCell(cell: cell, title: Constants.Strings.BillDetailVC.ProposeDateTitle, description: bill.proposeDate ?? "")
      break
      case BillDetailInfoType.status.rawValue:
      configureBillDetailTableViewCell(cell: cell, title:  Constants.Strings.BillDetailVC.StatusTitle, description: bill.status ?? "")
      break
      case BillDetailInfoType.sponsor.rawValue:
      configureBillDetailTableViewCell(cell: cell, title: Constants.Strings.BillDetailVC.SponsorTitle, description: bill.sponsor ?? "")
      break
      default:
      configureBillDetailTableViewCell(cell: cell, title: Constants.Strings.BillDetailVC.ExtenalLinkTitle, description: bill.documentUrl ?? "")
      break
    }
    
    return cell
    
    
  }
  
  func configureBillDetailTableViewCell(cell: BillDetailInfoTableViewCell, title: String, description: String) {
    cell.billDetailTitleLabel.text = title
    cell.billDetailDescLabel.text  = description
  }
  
  // MARK : - UITableViewDelegate Method

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.row == BillDetailInfoType.externalLink.rawValue {
      performSegue(withIdentifier: Constants.Identifier.segueToWebViewVC, sender: self)
    }
  }
  
}
