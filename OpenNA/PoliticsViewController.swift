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


class PoliticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK : - Property
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var lawmakers:[Lawmaker]!
    var bills:[Bill]!
    var parties:[Party]!

    struct cellIdentifier {
        static let PeopleCell = "PeopleCell"
        static let BillCell = "BillCell"
        static let PartyCell = "LogoImageCell"
    }

    // MARK : - View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: cellIdentifier.PeopleCell, bundle: nil), forCellReuseIdentifier: cellIdentifier.PeopleCell)
        
        self.tableView.registerNib(UINib(nibName: cellIdentifier.BillCell, bundle: nil), forCellReuseIdentifier: cellIdentifier.BillCell)

        lawmakers = fetchAllLawmakers()
        
    }

    // MARK : - CoreData Convenience
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }

    // MARK : - Data Fetch
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
    
    // MARK : - UITableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        switch segmentedControl.selectedSegmentIndex {
            
            case 0 :
                count = lawmakers.count
            case 1 :
                count = bills.count
                break
            case 2 :
                count = 0
                break
            default:
                break
        }
        
        return count
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch segmentedControl.selectedSegmentIndex {
            
            case 0:
                
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier.PeopleCell, forIndexPath: indexPath) as! PeopleTableViewCell
                configureCell(cell, atIndexPath: indexPath)
                return cell
        
            case 1:
                
                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier.BillCell, forIndexPath: indexPath) as! BillTableViewCell
                
                cell.nameLabel.text = bills[indexPath.row].name
                cell.sponsorLabel.text = bills[indexPath.row].sponsor
                cell.dateLabel.text = bills[indexPath.row].date
                cell.statusLabel.text = bills[indexPath.row].status
                return cell
            
        default:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier.BillCell, forIndexPath: indexPath) as! BillTableViewCell
            
            cell.nameLabel.text = bills[indexPath.row].name
            cell.sponsorLabel.text = bills[indexPath.row].sponsor
            cell.dateLabel.text = bills[indexPath.row].date
            cell.statusLabel.text = bills[indexPath.row].status
            return cell

            //default:
//                let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier.BillCell, forIndexPath: indexPath) as! PartyTableViewCell
//                return cell
            
        }
        
        
    }
        
    func configureCell(cell:PeopleTableViewCell , atIndexPath indexPath:NSIndexPath)
    {
        cell.nameLabel.text = lawmakers[indexPath.row].name
        cell.partyLabel.text = lawmakers[indexPath.row].party
        
        let url = NSURL(string: lawmakers[indexPath.row].imageUrl!)!

        //  The cells in the collection views get reused when you scroll
        //  So when a completion handler completes, it will set the image on a cell, 
        //  even if the cell is about to be reused, or is already being reused.
        
        //  The table view cells in FavoriteActors cancels their download task when they are reused. Take a look and see if that makes sense.
        
        let task = TPPClient.sharedInstance().taskForGetImage(url) { data, response, error  in
            
            if let data = data {
                
                let image = UIImage(data : data)
                
                dispatch_async(dispatch_get_main_queue()) {
                    cell.peopleImage!.image = image
                }
            }
        
        }
        
        cell.taskToCancelifCellIsReused = task
    }
    
    

    @IBAction func segmentedControlChanged(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            tableView.reloadData()
            break
        case 1:
            TPPClient.sharedInstance().getBills() { (bills, error) in
                
                if let bills = bills {

                    self.bills = bills
                    
                    performUIUpdatesOnMain {
                        self.tableView.reloadData()
                    }

                } else {
                    print(error)
                }
            }
            
            break
        default:
            break
        }
        
    }    
}

// MARK: - PoliticsViewController: UICollectionDelegate, UICollectionViewDataSource
extension PoliticsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK : - UICollectionViewDataSource Methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier.PartyCell, forIndexPath: indexPath) as! PartyCollectionViewCell
        
        configureCollectionCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    
    func configureCollectionCell(cell: PartyCollectionViewCell, atIndexPath indexPath : NSIndexPath) {
        
        
    }
}

