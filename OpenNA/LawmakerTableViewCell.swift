//
//  PeopleTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 10..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - LawmakerTableViewCell : TaskCancelingTableViewCell

class LawmakerTableViewCell : TaskCancelingTableViewCell {
  
  // MARK : - Property
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var partyLabel: UILabel!
  @IBOutlet weak var backgroundCardView: UIView!
  @IBOutlet weak var districtLabel: UILabel!
  @IBOutlet weak var separatorLabel: UILabel!
  @IBOutlet weak var nameTitleLabel: UILabel!
  
  let maximumDisctirctCharCount = 8
  var lawmakerInfo : Lawmaker! {
    didSet {
      updateCell()
    }
  }
  var lawmakerInListInfo : LawmakerInList! {
    didSet {
      updateCellInFavoriteList()
    }
  }
  
  // MARK : - Initialization
  
  override func awakeFromNib() {
    
    super.awakeFromNib()
    setContentViewBackground()
    configureBackgroundCardView()
  }
  
  func setContentViewBackground() {
    contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
  }
  
  func configureBackgroundCardView() {
    
    backgroundCardView.backgroundColor = UIColor.white
    backgroundCardView.layer.cornerRadius = 3.0
    backgroundCardView.layer.masksToBounds = false
    backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
    backgroundCardView.layer.shadowOpacity = 0.8
  }
  
  // MARK : - View Life Cycle
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setProfileImageViewCornerRadius()
  }
  
  func setProfileImageViewCornerRadius() {
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
    profileImageView.clipsToBounds = true
  }
  
  fileprivate func updateCell() {
    
    setNameLabel()
    setPartyLabel()
    setDistrictLabel()
    setProfileImage()
  }
  
  func setNameLabel() {
    nameLabel.text = lawmakerInfo.name
  }
  
  func setPartyLabel() {
    partyLabel.text = lawmakerInfo.party
  }
  
  func setDistrictLabel() {
    
    let district = lawmakerInfo.district ?? ""
    if district.characters.count <= maximumDisctirctCharCount {
      districtLabel.text = district
    } else {
      districtLabel.text = district.substring(to: district.index(district.startIndex, offsetBy: 6))
    }
  }
  
  func setProfileImage() {
  
    let urlString:String = lawmakerInfo.image ?? ""
    let url = URL(string: urlString)!
    
    guard let searchedLawmaker = CoreDataHelper.fetchLawmaker(from:urlString) else {
      return
    }
    
    var pinnedImage:UIImage?
    profileImageView.image = nil
    
    if searchedLawmaker.pinnedImage != nil {
      pinnedImage = searchedLawmaker.pinnedImage
    }
    else {
      
      let task = RestClient.sharedInstance().taskForGetImage(url) { data, error  in
        
        if let data = data {
          
          let image = UIImage(data : data)
          
          DispatchQueue.main.async {
            
            searchedLawmaker.pinnedImage = image
            
            UIView.transition(with: self.profileImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
              self.profileImageView!.image = image
            }, completion: nil)
            
          }
        }
      }
      
      taskToCancelifCellIsReused = task
    }
    
    profileImageView!.image = pinnedImage
    
  }
  
  
  fileprivate func updateCellInFavoriteList() {
    setNameInFavoriteList()
    setPartyInFavoriteList()
    setDistrictLabelInFavoriteList()
    setProfileImageInFavoriteList()
  }
  
  func setNameInFavoriteList() {
    nameLabel.text = lawmakerInListInfo.name
  }
  
  func setPartyInFavoriteList() {
    partyLabel.text = lawmakerInListInfo.party
  }
  
  func setDistrictLabelInFavoriteList() {
    
    let district = lawmakerInListInfo.district ?? ""
    if district.characters.count <= maximumDisctirctCharCount {
      districtLabel.text = district
    } else {
      districtLabel.text = district.substring(to: district.index(district.startIndex, offsetBy: 6))
    }
    
  }

  func setProfileImageInFavoriteList() {
    

    guard let urlString = lawmakerInListInfo.image else {
      return
    }
    
    let url = URL(string: urlString)!
    
    var pinnedImage:UIImage?
    profileImageView!.image = nil
    
    if  lawmakerInListInfo.pinnedImage != nil {
      pinnedImage = lawmakerInListInfo.pinnedImage
    }
    else {
      
      let task = RestClient.sharedInstance().taskForGetImage(url) { data, error  in
        
        if let data = data {
          
          let image = UIImage(data : data)
          
          DispatchQueue.main.async {
            self.lawmakerInListInfo.pinnedImage = image
            self.profileImageView!.image = image
          }
        }
      }
      self.taskToCancelifCellIsReused = task
    }
    self.profileImageView!.image = pinnedImage
  }
  
}
