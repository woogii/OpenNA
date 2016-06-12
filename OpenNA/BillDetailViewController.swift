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
    
    // MARK : Properties 
    
    @IBOutlet weak var assembylIDLabel: UILabel!
    @IBOutlet weak var proposedDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var documentURLLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    var bill:Bill?
    
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // MARK : View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(row, animated: false)
        }

        proposedDateLabel.text = bill?.proposeDate
        statusLabel.text = bill?.status
        sponsorLabel.text = bill?.sponsor
        documentURLLabel.text = bill?.documentUrl
        summaryTextView.text = bill?.summary
        
        guard let assemblyID = bill?.assemblyId  else {
            assembylIDLabel.text = ""
            return
        }
        
        assembylIDLabel.text = "\(assemblyID)"
        
        let fetchedResults = fetchBillInList()
        
        fetchedResults!.count == 0 ? (favoriteButton.tintColor = nil) : (favoriteButton.tintColor = UIColor.redColor())
    }
    
    // MARK : Fetch Bills in MyList
    
    func fetchBillInList()->[BillInList]?{
        print("bill name : \(bill?.name)")
        
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.BillInList)
        fetchRequest.predicate = NSPredicate(format: Constants.Fetch.PredicateForName, (bill?.name)!)
    
        // In order to fetch a single object
        fetchRequest.fetchLimit = 1
        
        var fetchedResults : [BillInList]?
        
        do {
            fetchedResults = try sharedContext.executeFetchRequest(fetchRequest) as? [BillInList]
        } catch let error as NSError {
            print("\(error.description)")
        }
        
        print("fetch result : \(fetchedResults)")
        
        return fetchedResults
    }
    
    // MARK : Action 
    
    @IBAction func favoriteButtonTapped(sender: UIBarButtonItem) {
        
        let fetchedResults = fetchBillInList()
        
        if fetchedResults!.count == 0  {
            
            var dictionary = [String:AnyObject]()
            
            dictionary[Constants.ModelKeys.BillName] = bill?.name
            dictionary[Constants.ModelKeys.BillProposedDate] = bill?.proposeDate
            dictionary[Constants.ModelKeys.BillSponsor] = bill?.sponsor
            dictionary[Constants.ModelKeys.BillStatus] = bill?.status
            dictionary[Constants.ModelKeys.BillSummary] = bill?.summary
            dictionary[Constants.ModelKeys.BillDocumentUrl] = bill?.documentUrl
            dictionary[Constants.ModelKeys.BillAssemblyId] = bill?.assemblyId
            
            let _ = BillInList(dictionary: dictionary, context: sharedContext)
            
            do {
                try sharedContext.save()
            } catch {
                print(error)
            }
            
            favoriteButton.tintColor = UIColor.redColor()
            
        } else {
            
            guard let result = fetchedResults!.first else {
                return
            }
            
            sharedContext.deleteObject(result)
            
            do {
                try sharedContext.save()
            } catch {
                print(error)
            }
            
            favoriteButton.tintColor = nil
        }
        
    }
    
    // MARK : Prepare Segue 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Identifier.segueToWebViewVC {
            let controller = segue.destinationViewController as! WebViewController
            controller.urlString = bill?.documentUrl
            controller.hidesBottomBarWhenPushed = true
        }
    }
    
    
}
