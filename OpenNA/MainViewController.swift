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

//    func imageLoad() {
//
//        let task = NSURLSession.sharedSession().dataTaskWithURL(lawmakers[0].imageUrl){
//            data,response, error in
//            
//            guard let data = data else {
//                print(error?.description)
//                return;
//            }
//        
//        let image = UIImage(data: data)
//        
//        task.resume()
//    }
    
   

    
    
    
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
        
        var count = 0
        
        switch segmentedControl.selectedSegmentIndex {
            
            case 0 :
                count = lawmakers.count
            case 1 :
                count = 0
                break
            case 2 :
                count = 0
                break
            default:
                break
        }
        
        return count
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        
        
        switch segmentedControl.selectedSegmentIndex {
            
            case 0:
                configureCell(cell, atIndexPath: indexPath)
                break
            case 1:
                break
            case 2:
                break
            default:
                break
        }
        

        
        
        return cell
    }
        
    func configureCell(cell:UITableViewCell, atIndexPath indexPath:NSIndexPath)
    {
        cell.textLabel!.text = lawmakers[indexPath.row].name
        //cell.detailTextLabel!.text = lawmakers[indexPath.row].party
        
        let url = NSURL(string: lawmakers[indexPath.row].imageUrl!)!
        print(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){  data,response, error in
        
            guard let data = data else {
                print(error?.description)
                return
            }
            
            let image = UIImage(data: data)
            
            
            dispatch_async(dispatch_get_main_queue()) {
                cell.imageView!.image = image
            }
            
        }
        
        task.resume()

    }
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        tableView.reloadData()
    }

}

