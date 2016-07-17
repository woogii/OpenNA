//
//  SearchedLawmakerDetailViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 6. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK : - SearchedLawmakerDetailViewController: UIViewController 

class SearchedLawmakerDetailViewController: UIViewController {
    
    // MARK : - Property
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var image:String?
    var name : String?
    var birth:String?
    var address: String?
    var blog : String?
    var education : String?
    var homepage:String?
    
    
    // MARK : - Enum (For Cell IndexPath Row)
    
    enum CustomCell:Int {
        case Birth = 0, Address, Blog, Education, Homepage
    }
    
    // MARK : - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let row = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(row, animated: false)
        }
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
        if let imageString = image {
            
            let url = NSURL(string: imageString)
        
            TPPClient.sharedInstance().taskForGetImage(url!) { data, error  in
            
                if let data = data {
                
                    let image = UIImage(data : data)
                
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.profileImage!.image = image
                    }
                } else {
                    CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                                  okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
                }
            }
        } else {
            profileImage.image = UIImage(named: Constants.Strings.SearchedLawmakerDetailVC.defaultImageName)
        }

        // profileImage.image = pinnedImage
        nameLabel.text = name!
    
    }
    
    // MARK : - Prepare For Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Identifier.segueToWebViewVC {
            let controller = segue.destinationViewController as! WebViewController
            controller.urlString = homepage
        }
    }

}

// MARK: - SearchedLawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource

extension SearchedLawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    // MARK : - UITableViewDataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.Strings.LawmakerDetailVC.NumOfProfileCells
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch(indexPath.row) {
            
        case CustomCell.Birth.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedLawmakerDetailCell, forIndexPath: indexPath) as? SearchedLawmakerDetailTableViewCell {
                cell.titleLabel.text = Constants.CustomCell.BirthLabel
                cell.descriptionLabel.text = birth
                return cell
            }
        case CustomCell.Address.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedLawmakerDetailCell, forIndexPath: indexPath) as? SearchedLawmakerDetailTableViewCell {
                cell.titleLabel.text = Constants.CustomCell.AddressLabel
                cell.descriptionLabel.text = address
                return cell
            }
        case CustomCell.Blog.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedLawmakerDetailCell, forIndexPath: indexPath) as? SearchedLawmakerDetailTableViewCell {
                cell.titleLabel.text = Constants.CustomCell.BlogLabel
                cell.descriptionLabel.text = blog
                return cell
            }
        case CustomCell.Education.rawValue:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedLawmakerDetailCell, forIndexPath: indexPath) as? SearchedLawmakerDetailTableViewCell {
                cell.titleLabel.text = Constants.CustomCell.EducationLabel
                cell.descriptionLabel.text = education
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.SearchedLawmakerDetailCell, forIndexPath: indexPath) as? SearchedLawmakerDetailTableViewCell {
                cell.titleLabel.text = Constants.CustomCell.HomepageLabel
                cell.descriptionLabel.text = homepage
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.Strings.LawmakerDetailVC.HeaderTitle
    }
    
}