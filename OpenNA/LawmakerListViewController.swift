//
//  LawmakerListViewController.swift
//  OpenNA
//
//  Created by TeamSlogup on 2016. 5. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LawmakerListViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var lawmakersInList = [LawmakerInList]()
    
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    override func viewWillAppear(animated: Bool) {
        
        lawmakersInList = fetchLawmakersInList()
        print("count : \(lawmakersInList.count)")
    }
    
    func  fetchLawmakersInList()->[LawmakerInList] {
        
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.LawmakerInList)
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [LawmakerInList]
            
        } catch let error as NSError {
            print("\(error.description)")
            return [LawmakerInList]()
        }
        
    }
    
    override func viewDidLoad() {
        // Register Nib Objects
        tableView.registerNib(UINib(nibName: Constants.Identifier.LawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.LawmakerCell)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = tableView.indexPathForSelectedRow!
        
        let detailVC = segue.destinationViewController as! LawmakerDetailViewController
        
        detailVC.image = lawmakersInList[path.row].pinnedImage
        detailVC.hidesBottomBarWhenPushed = true
        
        
    }
    
}

extension LawmakerListViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.LawmakerCell, forIndexPath: indexPath) as! LawmakerTableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell:LawmakerTableViewCell , atIndexPath indexPath:NSIndexPath)
    {
        
        cell.nameLabel.text = lawmakersInList[indexPath.row].name
        print(lawmakersInList[indexPath.row].name)
        cell.partyLabel.text = lawmakersInList[indexPath.row].party
        let urlString:String? = lawmakersInList[indexPath.row].image
        let url = NSURL(string: urlString!)!
        
        var pinnedImage:UIImage?
        cell.imageView!.image = nil
        
        if  lawmakersInList[indexPath.row].pinnedImage != nil {
            #if DEBUG
                log.debug("images exist")
            #endif
            pinnedImage = lawmakersInList[indexPath.row].pinnedImage
        }
        else {
            
            let task = TPPClient.sharedInstance().taskForGetImage(url) { data, error  in
                
                if let data = data {
                    
                    let image = UIImage(data : data)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.lawmakersInList[indexPath.row].pinnedImage = image
                        cell.profileImageView!.image = image
                    }
                }
                
            }
            
            cell.taskToCancelifCellIsReused = task
        }
        
        cell.profileImageView!.image = pinnedImage
        
    }
    
    // MARK : UITableView Delegate Method
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.Identifier.LawmakerDetailVC, sender: self)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("lawmakers In List \(lawmakersInList.count)")
        return lawmakersInList.count
    }
    
    
}