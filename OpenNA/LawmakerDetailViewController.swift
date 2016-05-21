//
//  LawmakerDetailViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 4. 2..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LawmakerDetailViewController : UIViewController

class LawmakerDetailViewController: UIViewController {
    
    // MARK : Properties

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var lawmaker:Lawmaker? 
    var image:UIImage?
    
    enum customCell:Int {
        case birth = 0,party,inOffice,district,homepage
    }
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear(animated: Bool) {
    
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.image = image
        
        nameLabel.text = lawmaker?.name
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Identifier.segueToHomepageVC {
            let controller = segue.destinationViewController as! WebViewController
            controller.urlString = lawmaker?.homepage
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
            
        case customCell.birth.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.BirthCell, forIndexPath: indexPath) as? BirthTableViewCell {
                cell.title.text = Constants.CustomCell.BirthLabel
                cell.birthDesc.text = lawmaker?.birth
                return cell
            }
        case customCell.party.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.PartyCell, forIndexPath: indexPath) as? PartyTableViewCell {
                cell.title.text = Constants.CustomCell.PartyLabel
                cell.partyDesc.text = lawmaker?.party
                return cell
            }
        case customCell.inOffice.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.InOfficeCell, forIndexPath: indexPath) as? InOfficeTableViewCell {
                cell.title.text = Constants.CustomCell.InOfficeLabel
                cell.inOfficeDesc.text = lawmaker?.when_elected
                return cell
            }
        case customCell.district.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.DistrictCell, forIndexPath: indexPath) as? DistrictTableViewCell {
                cell.title.text = Constants.CustomCell.DistrictLabel
                cell.districtDesc.text = lawmaker?.district
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.HomepageCell, forIndexPath: indexPath) as? HomepageTableViewCell {
                cell.title.text = Constants.CustomCell.HomepageLabel
                cell.homepageDesc.text = lawmaker?.homepage
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.HeaderTitle
    }
    
}