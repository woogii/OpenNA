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
  @IBOutlet weak var favoriteButton: UIButton!
  var lawmaker:Lawmaker!
 
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    hideFavoriteButton()
    requestProfileImage()
    setNameLabel()
  }
  
  func hideFavoriteButton() {
    favoriteButton.isHidden = true 
  }
  
  func setNameLabel() {
    nameLabel.text = lawmaker.name ?? ""
  }
  
  func requestProfileImage() {
    
    if let imageString = lawmaker.image {
      
      let url = URL(string: imageString)
      
      _ = RestClient.sharedInstance().taskForGetImage(url!) { data, error  in
        
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

    
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    makeCircleProfileImageView()
  }
  
  func makeCircleProfileImageView() {
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2
    profileImage.clipsToBounds = true
  }
  
  
  
  // MARK : - Prepare For Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == Constants.Identifier.segueToWebViewVC {
      let controller = segue.destination as! WebViewController
      controller.urlString = lawmaker.homepage
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
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as!SearchedLawmakerDetailTableViewCell
      configureSearchedLawmakerDetailTableViewCell(cell: cell,title: Constants.CustomCell.BirthLabelKr,description: lawmaker.birth)
      return cell
      
    case CustomCell.address.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as! SearchedLawmakerDetailTableViewCell
      configureSearchedLawmakerDetailTableViewCell(cell: cell, title: Constants.CustomCell.AddressLabelKr,description: lawmaker.address)
      return cell
      
    case CustomCell.blog.rawValue:
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as! SearchedLawmakerDetailTableViewCell
      configureSearchedLawmakerDetailTableViewCell(cell: cell, title:  Constants.CustomCell.BlogLabelKr, description: lawmaker.blog)
      return cell
      
    case CustomCell.education.rawValue:
      
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as! SearchedLawmakerDetailTableViewCell
      configureSearchedLawmakerDetailTableViewCell(cell: cell, title:Constants.CustomCell.EducationLabelKr, description: lawmaker.education)
      return cell
      
    default:
  
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as! SearchedLawmakerDetailTableViewCell
      configureSearchedLawmakerDetailTableViewCell(cell: cell, title:Constants.CustomCell.HomepageLabelKr, description: lawmaker.homepage)
      return cell
      
    }
    
    
  }
  
  func configureSearchedLawmakerDetailTableViewCell(cell:SearchedLawmakerDetailTableViewCell,title:String, description:String?) {
    cell.titleLabel.text = title
    cell.descriptionLabel.text = description
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return Constants.Strings.LawmakerDetailVC.HeaderTitle
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.row == CustomCell.blog.rawValue {
      
      guard lawmaker.blog != "" else {
        return
      }
      
      let webVC = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.WebViewVC) as! WebViewController
      webVC.urlString = lawmaker.blog
      navigationController?.pushViewController(webVC, animated: true)
      
    } else if indexPath.row == CustomCell.homepage.rawValue {
      
      guard lawmaker.homepage != "" else {
        return
      }
      
      let webVC = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.WebViewVC) as! WebViewController
      webVC.urlString = lawmaker.homepage
      navigationController?.pushViewController(webVC, animated: true)
    }

    
  }

}
