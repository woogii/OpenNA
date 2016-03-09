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


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var lawmakers:[Lawmaker]!
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        lawmakers = fetchAllLawmakers()
        print(lawmakers.count)
    }

    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    func fetchAllLawmakers()->[Lawmaker]
    {
        let fetchRequest = NSFetchRequest(entityName : "Lawmaker")
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Lawmaker]
            
        } catch let error as NSError {
            print("\(error.description)")
            return [Lawmaker]()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lawmakers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.textLabel!.text = lawmakers[indexPath.row].name
        cell.detailTextLabel!.text = lawmakers[indexPath.row].party
        
        
        return cell
    }
    
    func loadData() {
        
      
        
//        guard let rawAJSONData = NSData(contentsOfFile:pathForJSONData) else {
//            print("Can not get a raw JSON data in \(pathForJSONData)")
//            return
//        }
//        
//        let parsedResult:[[String:AnyObject]]!
//        do {
//            parsedResult = try NSJSONSerialization.JSONObjectWithData(rawAJSONData, options: .AllowFragments) as! [[String:AnyObject]]
//            
//            print(parsedResult.count)
//            
//            for dict in parsedResult {
//                //print(dict)
//                guard let name = dict["name_kr"] as? String else {
//                    print("test")
//                    return
//                }
//                lawmakers.append(name)
//            }
//            
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        
//        tableView.reloadData()
        
    }
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        
    }
    
    
}

