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
    var bills = [BillInList]()
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    override func viewWillAppear(animated: Bool) {
        
        bills = fetchBillsInList()
    }
    
    override func viewDidLoad() {
        
        tableView.registerNib(UINib(nibName: Constants.Identifier.BillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.BillCell)
        tableView.delegate = self
        tableView.dataSource = self
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
    
    
}

extension BillListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.BillCell, forIndexPath: indexPath) as! BillTableViewCell
        
        cell.nameLabel.text    = bills[indexPath.row].name
        cell.sponsorLabel.text = bills[indexPath.row].sponsor
        cell.dateLabel.text    = bills[indexPath.row].proposeDate
        cell.statusLabel.text  = bills[indexPath.row].status
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    // MARK : UITableView Delegate Method
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    
}