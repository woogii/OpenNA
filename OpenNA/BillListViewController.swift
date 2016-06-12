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

class BillListViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var billsInList = [BillInList]()
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(row, animated: false)
        }

    }
    
    override func viewDidLoad() {
        
        tableView.registerNib(UINib(nibName: Constants.Identifier.BillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.BillCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        billsInList = fetchBillsInList()
    }
    
    func  fetchBillsInList()->[BillInList] {
        
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.BillInList)
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [BillInList]
            
        } catch let error as NSError {
            print("\(error.description)")
            return [BillInList]()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = tableView.indexPathForSelectedRow!
        
        let detailVC = segue.destinationViewController as! BillDetailViewController
        
        detailVC.name = billsInList[path.row].name
        detailVC.proposedDate = billsInList[path.row].proposeDate
        detailVC.sponsor = billsInList[path.row].sponsor
        detailVC.status = billsInList[path.row].status
        detailVC.summary = billsInList[path.row].summary
        detailVC.documentUrl = billsInList[path.row].documentUrl
        detailVC.assemblyID = billsInList[path.row].assemblyId as? Int
        
        detailVC.hidesBottomBarWhenPushed = true
        
    }

}

extension BillListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.BillCell, forIndexPath: indexPath) as! BillTableViewCell
        
        cell.nameLabel.text    = billsInList[indexPath.row].name
        cell.sponsorLabel.text = billsInList[indexPath.row].sponsor
        cell.statusLabel.text  = billsInList[indexPath.row].status
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billsInList.count
    }
    
    // MARK : UITableView Delegate Method
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.Identifier.BillDetailVC, sender: self)
    }

}