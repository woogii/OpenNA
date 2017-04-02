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

// MARK : - LawmakerDetailViewController : UIViewController

class LawmakerDetailViewController: UIViewController {
  
  // MARK : - Property
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var favoriteButton: UIButton!
  
  var lawmaker:Lawmaker!
  
  // MARK : - CoreData Convenience
  
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
    
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setProfileImage()
    setName()
  }
  
  func setProfileImage() {
    profileImage.image = lawmaker.pinnedImage
  }
  
  func setName() {
  
    if let name = lawmaker.name {
      nameLabel.text = name
    } else {
      nameLabel.text = ""
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setFavoriteIconAfterFetchLawmaker()
  }
  
  func setFavoriteIconAfterFetchLawmaker() {
    
    let fetchedResults = CoreDataHelper.fetchLawmakerInList(name: lawmaker.name, image: lawmaker.image)
    fetchedResults!.count == 0 ? (favoriteButton.setImage(UIImage(named:Constants.Images.FavoriteIconEmpty), for: .normal)) : (favoriteButton.setImage(UIImage(named:Constants.Images.FavoriteIconFilled), for: .normal))
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
  
  // MARK : - Action Method
  
  @IBAction func favoriteBtnTapped(_ sender: UIButton) {
    
    let fetchedResults = CoreDataHelper.fetchLawmakerInList(name: nameLabel.text!, image: lawmaker.image)
    
    // If there is not a lawmaker in Favorite List, add it to the list
    if fetchedResults!.count == 0  {
      
      _ = LawmakerInList(name: lawmaker.name,image: lawmaker.image,party: lawmaker.party, birth: lawmaker.birth, homepage: lawmaker.homepage, when_elected: lawmaker.when_elected, district: lawmaker.district,  context: sharedContext)
      
      do {
        try sharedContext.save()
      } catch {
        #if DEBUG
          print("\(error)")
        #endif
      }
      
      favoriteButton.setImage(UIImage(named:Constants.Images.FavoriteIconFilled), for: .normal)
    } else {
      
      // If the lawmaker is already in Favorite List, delete it from the list
      
      guard let result = fetchedResults!.first else {
        return
      }
      
      sharedContext.delete(result)
      
      do {
        try sharedContext.save()
      } catch {
        #if DEBUG
          print("\(error)")
        #endif
      }
      
      favoriteButton.setImage(UIImage(named:Constants.Images.FavoriteIconEmpty),  for: .normal)
    }
  }
  
  @IBAction func pushBackButton(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
  }
  
}

// MARK: - LawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource

extension LawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource {
  
  // MARK : - UITableViewDataSource Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Constants.Strings.LawmakerDetailVC.NumOfProfileCells
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.LawmakerDetailCell, for: indexPath) as! LawmakerDetailTableViewCell
    
    switch(indexPath.row) {
      
    case LawmakerDetailInfoType.birth.rawValue:
      configureLawmakerDetailTableViewCell(cell: cell, title: Constants.CustomCell.BirthLabelKr, description: lawmaker.birth)
      break
    case LawmakerDetailInfoType.party.rawValue:
      configureLawmakerDetailTableViewCell(cell: cell, title: Constants.CustomCell.PartyLabelKr, description: lawmaker.party)
      break
    case LawmakerDetailInfoType.inOffice.rawValue:
      configureLawmakerDetailTableViewCell(cell: cell, title: Constants.CustomCell.InOfficeLabelKr, description: lawmaker.when_elected)
      break
    case LawmakerDetailInfoType.district.rawValue:
      configureLawmakerDetailTableViewCell(cell: cell, title: Constants.CustomCell.DistrictLabelKr, description: lawmaker.district)
      break
    default:
      configureLawmakerDetailTableViewCell(cell: cell, title: Constants.CustomCell.HomepageLabelKr, description: lawmaker.homepage)
      break
    }
    
    return cell
  }
  
  func configureLawmakerDetailTableViewCell(cell:LawmakerDetailTableViewCell,title:String, description:String?) {
    cell.titleLabel.text = title
    cell.descriptionLabel.text = description
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return Constants.Strings.LawmakerDetailVC.HeaderTitle
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    if indexPath.row == LawmakerDetailInfoType.homepage.rawValue {
      
      guard lawmaker.homepage != "" else {
        return
      }
      
      let webVC = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.WebViewVC) as! WebViewController
      webVC.urlString = lawmaker.homepage
      navigationController?.pushViewController(webVC, animated: true)
    }
    
  }
  
  
}
