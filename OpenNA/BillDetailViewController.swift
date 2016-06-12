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
    
    // var bill:Bill?
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
    
    // MARK : View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(row, animated: false)
        }

        proposedDateLabel.text = proposedDate
        statusLabel.text = status
        sponsorLabel.text = sponsor
        documentURLLabel.text = documentUrl
        summaryTextView.text = summary
        
        guard let assemblyID = assemblyID  else {
            assembylIDLabel.text = ""
            return
        }
        
        assembylIDLabel.text = "\(assemblyID)"
        
        let fetchedResults = fetchBillInList()
        
        fetchedResults!.count == 0 ? (favoriteButton.tintColor = nil) : (favoriteButton.tintColor = UIColor.redColor())
    }
    
    // MARK : Fetch Bills in MyList
    
    func fetchBillInList()->[BillInList]?{
        print("bill name : \(name!)")
        
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.BillInList)
        fetchRequest.predicate = NSPredicate(format: Constants.Fetch.PredicateForName, name!)
    
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
            
            dictionary[Constants.ModelKeys.BillName] = name
            dictionary[Constants.ModelKeys.BillProposedDate] = proposedDate
            dictionary[Constants.ModelKeys.BillSponsor] = sponsor
            dictionary[Constants.ModelKeys.BillStatus] = status
            dictionary[Constants.ModelKeys.BillSummary] = summary
            dictionary[Constants.ModelKeys.BillDocumentUrl] = documentUrl
            dictionary[Constants.ModelKeys.BillAssemblyId] = assemblyID
            
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
            controller.urlString = documentUrl
            controller.hidesBottomBarWhenPushed = true
        }
    }
    
    
}
