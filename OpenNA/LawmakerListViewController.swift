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

// MARK : - LawmakerListViewController : UIViewController

class LawmakerListViewController : UIViewController {
    
    // MARK : - Property 
    
    @IBOutlet weak var tableView: UITableView!
    var lawmakersInList = [LawmakerInList]()
    
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // MARK : - View Life Cycle 
    
    override func viewWillAppear(animated: Bool) {
        
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(row, animated: false)
        }
        
        lawmakersInList = fetchLawmakersInList()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        // Register Nib Objects
        tableView.registerNib(UINib(nibName: Constants.Identifier.LawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.LawmakerCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        lawmakersInList = fetchLawmakersInList()
        
    }
    
    // MARK : - Fetch Lawmakers In Favorite List
    
    func fetchLawmakersInList()->[LawmakerInList] {
        
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.LawmakerInList)
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [LawmakerInList]
            
        } catch let error as NSError {
            #if DEBUG
                log.debug("\(error.description)")
            #endif
            return [LawmakerInList]()
        }
        
    }
    
    // MARK : - Prepare For Segue 
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = tableView.indexPathForSelectedRow!
        
        let detailVC = segue.destinationViewController as! LawmakerDetailViewController
    
        detailVC.pinnedImage = lawmakersInList[path.row].pinnedImage
        detailVC.name = lawmakersInList[path.row].name
        detailVC.birth = lawmakersInList[path.row].birth
        detailVC.party = lawmakersInList[path.row].party
        detailVC.when_elected = lawmakersInList[path.row].when_elected
        detailVC.district = lawmakersInList[path.row].when_elected
        detailVC.homepage = lawmakersInList[path.row].homepage
        detailVC.image = lawmakersInList[path.row].image
        detailVC.pinnedImage = lawmakersInList[path.row].pinnedImage

        detailVC.hidesBottomBarWhenPushed = true
        
    }
    
}

// MARK : - LawmakerListViewController : UITableViewDelegate, UITableViewDataSource 

extension LawmakerListViewController : UITableViewDelegate, UITableViewDataSource {
    
    

    // MARK : - UITableViewDataSource Methods

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var numberOfSection = 0
        
        if lawmakersInList.count > 0 {
            
            self.tableView.backgroundView = nil
            numberOfSection = 1
            
            
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height))
            noDataLabel.text = Constants.Strings.LawmakerListVC.DefaultLabelMessage
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.Center
            self.tableView.backgroundView = noDataLabel
            
        }
        
        return numberOfSection
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.LawmakerCell, forIndexPath: indexPath) as! LawmakerTableViewCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell:LawmakerTableViewCell , atIndexPath indexPath:NSIndexPath)
    {
        
        cell.nameLabel.text = lawmakersInList[indexPath.row].name
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lawmakersInList.count
    }
    
    // MARK : UITableView Delegate Methods
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(Constants.Identifier.LawmakerDetailVC, sender: self)
    }
    

    
}