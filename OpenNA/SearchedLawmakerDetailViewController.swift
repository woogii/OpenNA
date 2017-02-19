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
    case birth = 0, address, blog, education, homepage
  }
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    if let row = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: row, animated: false)
    }
    
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2
    profileImage.clipsToBounds = true
    
    if let imageString = image {
      
      let url = URL(string: imageString)
      
      _ = TPPClient.sharedInstance().taskForGetImage(url!) { data, error  in
        
        if let data = data {
          
          let image = UIImage(data : data)
          
          DispatchQueue.main.async {
            
            self.profileImage!.image = image
          }
        } else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
        }
      }
    } else {
      profileImage.image = UIImage(named: Constants.Strings.SearchVC.defaultImageName)
    }
    
    // profileImage.image = pinnedImage
    nameLabel.text = name!
    
  }
  
  // MARK : - Prepare For Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == Constants.Identifier.segueToWebViewVC {
      let controller = segue.destination as! WebViewController
      controller.urlString = homepage
    }
  }
  
  @IBAction func pushBackButton(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
  }
}

// MARK: - SearchedLawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource

extension SearchedLawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource {
  
  // MARK : - UITableViewDataSource Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Constants.Strings.LawmakerDetailVC.NumOfProfileCells
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch(indexPath.row) {
      
    case CustomCell.birth.rawValue:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.BirthLabel
        cell.descriptionLabel.text = birth
        return cell
      }
    case CustomCell.address.rawValue:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.AddressLabel
        cell.descriptionLabel.text = address
        return cell
      }
    case CustomCell.blog.rawValue:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.BlogLabel
        cell.descriptionLabel.text = blog
        return cell
      }
    case CustomCell.education.rawValue:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.EducationLabel
        cell.descriptionLabel.text = education
        return cell
      }
    default:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.HomepageLabel
        cell.descriptionLabel.text = homepage
        return cell
      }
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return Constants.Strings.LawmakerDetailVC.HeaderTitle
  }
  
}
