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

// MARK: - PoliticsViewController : UIViewController

class PoliticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK : Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var lawmakers:[Lawmaker]!
    var bills:[Bill]!
    var parties = [Party]()

    struct cellIdentifier {
        static let PeopleCell = "PeopleCell"
        static let BillCell = "BillCell"
        static let PartyCell = "LogoImageCell"
    }
    
    // MARK :  View Life Cycle
    
    override func viewDidLayoutSubviews() {
        
        print("ViewDidLayoutSubviews")
        super.viewDidLayoutSubviews()
        
        // Lay out the collection view so that cells take up 1/3 of the width,
        // with no space in between
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = floor(self.collectionView.frame.size.width/3)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: cellIdentifier.PeopleCell, bundle: nil), forCellReuseIdentifier: cellIdentifier.PeopleCell)
        
        self.tableView.registerNib(UINib(nibName: cellIdentifier.BillCell, bundle: nil), forCellReuseIdentifier: cellIdentifier.BillCell)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.hidden = true 

        lawmakers = fetchAllLawmakers()
    
        
    }

    // MARK :  CoreData Convenience
    
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }

    // MARK :  Data Fetch
    
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
    
    // MARK : UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        switch segmentedControl.selectedSegmentIndex {
            
            case 0 :
                count = lawmakers.count
                break
            case 1 :
                count = bills.count
                break
            case 2 :
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
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier.PeopleCell, forIndexPath: indexPath) as! PeopleTableViewCell
            configureCell(cell, atIndexPath: indexPath)
            return cell
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier.BillCell, forIndexPath: indexPath) as! BillTableViewCell
                
            cell.nameLabel.text = bills[indexPath.row].name
            cell.sponsorLabel.text = bills[indexPath.row].sponsor
            cell.dateLabel.text = bills[indexPath.row].date
            cell.statusLabel.text = bills[indexPath.row].status
            
            return cell
        }

        return UITableViewCell()
    }

    // MARK : Congifure UITableviewCell
    
    func configureCell(cell:PeopleTableViewCell , atIndexPath indexPath:NSIndexPath)
    {
        cell.nameLabel.text = lawmakers[indexPath.row].name
        cell.partyLabel.text = lawmakers[indexPath.row].party
        
        let url = NSURL(string: lawmakers[indexPath.row].imageUrl!)!

        
        let task = TPPClient.sharedInstance().taskForGetImage(url) { data, error  in
            
            if let data = data {
                
                let image = UIImage(data : data)
                
                dispatch_async(dispatch_get_main_queue()) {
                    cell.peopleImage!.image = image
                }
            }
        
        }
        
        //  The cells in the tableviews get reused when you scroll
        //  So when a completion handler completes, it will set the image on a cell,
        //  even if the cell is about to be reused, or is already being reused.
        //  The table view cells need to cancel their download task when they are reused.
        cell.taskToCancelifCellIsReused = task
    }
    
    
    // MARK : Action Method
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            tableView.hidden = false
            tableView.reloadData()
            break
        case 1:
            tableView.hidden = false
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
        case 2:
            collectionView.hidden = false
            tableView.hidden = true
            
            TPPClient.sharedInstance().getParties() { (parties, error) in
            
                if let parties = parties {
                    print(parties)
                    self.parties = parties
                    
                    performUIUpdatesOnMain {
                        self.collectionView.reloadData()
                    }
                }
                else {
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
  
    // MARK : UICollectionViewDataSource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return parties.count 
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier.PartyCell, forIndexPath: indexPath) as! PartyCollectionViewCell
        
        //configureCollectionCell(cell, atIndexPath: indexPath)
        cell.logoImageView.image = parties[indexPath.row].thumbnail
        
        return cell
    }
    
}

