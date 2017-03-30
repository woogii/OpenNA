//
//  BillListViewController.swift
//  OpenNA
//
//  Created by TeamSlogup on 2016. 5. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK : - BillListViewController : UIViewController

class BillListViewController : UIViewController {
  
  // MARK : - Property
  
  @IBOutlet weak var tableView: UITableView!
  var billsInList = [BillInList]()
  let rowHeight:CGFloat = 140
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  // MARK : - View Life Cycle
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    
    getBillList()
    tableView.reloadData()
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    registerNibForTableView()
    
  }
  
  func registerNibForTableView() {
    
    tableView.register(UINib(nibName: Constants.Identifier.BillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.BillCell)
    
  }
  
  func getBillList() {
    billsInList = fetchBillsInList()
  }

  // MARK  : - Fetch Bills in Favorite List
  
  func fetchBillsInList()->[BillInList] {
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.BillInList)
    
    do {
      return try sharedContext.fetch(fetchRequest) as! [BillInList]
      
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
      return [BillInList]()
    }
  }
  
  // MARK : - Prepare For Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let path = tableView.indexPathForSelectedRow!
    let detailVC = segue.destination as! BillDetailViewController
    
    detailVC.bill = Bill.extractBill(from:billsInList[path.row])
    detailVC.hidesBottomBarWhenPushed = true
    
  }
  
  @IBAction func pushBackButton(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
  }
  
}

// MARK : - BillListViewController : UITableViewDelegate, UITableViewDataSource

extension BillListViewController : UITableViewDelegate, UITableViewDataSource {
  
  // MARK : - UITableViewDataSource Method
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    var numberOfSection = 0
    
    if billsInList.count > 0 {
      
      tableView.backgroundView = nil
      numberOfSection = 1
    
    } else {
      
      let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
      noDataLabel.text = Constants.Strings.BillListVC.DefaultLabelMessageKr
      noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
      noDataLabel.textAlignment = NSTextAlignment.center
      tableView.backgroundView = noDataLabel
      
    }
    
    return numberOfSection
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.BillCell, for: indexPath) as! BillTableViewCell
    
    cell.nameLabel.text    = billsInList[indexPath.row].name
    cell.sponsorLabel.text = billsInList[indexPath.row].sponsor
    cell.statusLabel.text  = billsInList[indexPath.row].status
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return billsInList.count
  }
  
  // MARK : - UITableView Delegate Method
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return rowHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    performSegue(withIdentifier: Constants.Identifier.BillDetailVC, sender: self)
  }
  
}
