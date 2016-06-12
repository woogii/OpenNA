//
//  LawmakerDetailViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 4. 2..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK: - LawmakerDetailViewController : UIViewController

class LawmakerDetailViewController: UIViewController {
    
    // MARK : Properties
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // var lawmaker:Lawmaker?
    
    var image:String?
    var birth:String?
    var party:String?
    var when_elected:String?
    var district:String?
    var homepage:String?
    var name : String?
    var pinnedImage:UIImage?

    
    // MARK :  CoreData Convenience
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // MARK : Enumeration Cases
    enum CustomCell:Int {
        case Birth = 0,Party,InOffice,District,Homepage
    }
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(row, animated: false)
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.image = pinnedImage
        
        nameLabel.text = name!
        
        let fetchedResults = fetchLawmakerInList()
        
        fetchedResults!.count == 0 ? (favoriteButton.tintColor = nil) : (favoriteButton.tintColor = UIColor.redColor())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Identifier.segueToWebViewVC {
            let controller = segue.destinationViewController as! WebViewController
            controller.urlString = homepage // lawmaker?.homepage
        }
    }
    
    func fetchLawmakerInList()->[LawmakerInList]? {
        
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.LawmakerInList)
        let firstPredicate = NSPredicate(format: Constants.Fetch.PredicateForName, name!)
        let secondPredicate = NSPredicate(format: Constants.Fetch.PredicateForImage, image!)
        let compoundPredicate = NSCompoundPredicate(type: .AndPredicateType, subpredicates:[firstPredicate,secondPredicate])
        fetchRequest.predicate = compoundPredicate
        
        // In order to fetch a single object
        fetchRequest.fetchLimit = 1
        
        
        var fetchedResults : [LawmakerInList]?
        
        do {
            fetchedResults = try sharedContext.executeFetchRequest(fetchRequest) as? [LawmakerInList]
        } catch let error as NSError {
            print("\(error.description)")
        }
        
        print("fetch result : \(fetchedResults)")
        
        return fetchedResults
    }
    
    @IBAction func favoriteBtnTapped(sender: UIButton) {
        
        let fetchedResults = fetchLawmakerInList()
        
        if fetchedResults!.count == 0  {
            
            var dictionary = [String:AnyObject]()
            
            dictionary[Constants.ModelKeys.Name] =  name
            dictionary[Constants.ModelKeys.ImageUrl] = image
            dictionary[Constants.ModelKeys.Party] =  party
            dictionary[Constants.ModelKeys.Birth] =  birth
            dictionary[Constants.ModelKeys.Homepage] = homepage
            dictionary[Constants.ModelKeys.WhenElected] = when_elected
            dictionary[Constants.ModelKeys.District] = district
            
            let _ = LawmakerInList(dictionary: dictionary, context: sharedContext)
            
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
            
            print("lawmaker delete")
            sharedContext.deleteObject(result)
            
            do {
                try sharedContext.save()
            } catch {
                print(error)
            }
            
            favoriteButton.tintColor = nil
        }
    }
}

// MARK: - LawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource

extension LawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.NumOfProfileCells
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch(indexPath.row) {
            
        case CustomCell.Birth.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.BirthCell, forIndexPath: indexPath) as? BirthTableViewCell {
                cell.title.text = Constants.CustomCell.BirthLabel
                cell.birthDesc.text = birth
                return cell
            }
        case CustomCell.Party.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.PartyCell, forIndexPath: indexPath) as? PartyTableViewCell {
                cell.title.text = Constants.CustomCell.PartyLabel
                cell.partyDesc.text = party
                return cell
            }
        case CustomCell.InOffice.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.InOfficeCell, forIndexPath: indexPath) as? InOfficeTableViewCell {
                cell.title.text = Constants.CustomCell.InOfficeLabel
                cell.inOfficeDesc.text = when_elected
                return cell
            }
        case CustomCell.District.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.DistrictCell, forIndexPath: indexPath) as? DistrictTableViewCell {
                cell.title.text = Constants.CustomCell.DistrictLabel
                cell.districtDesc.text = district
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.HomepageCell, forIndexPath: indexPath) as? HomepageTableViewCell {
                cell.title.text = Constants.CustomCell.HomepageLabel
                cell.homepageDesc.text = homepage 
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.HeaderTitle
    }
    
}