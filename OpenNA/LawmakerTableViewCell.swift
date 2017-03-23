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
  
    // Configure view layer to make it look like Card-style view
    backgroundCardView.backgroundColor = UIColor.white
    backgroundCardView.layer.cornerRadius = 3.0
    backgroundCardView.layer.masksToBounds = false
    backgroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
    backgroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
    backgroundCardView.layer.shadowOpacity = 0.8
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setProfileImageViewCornerRadius()
  }
  
  func setProfileImageViewCornerRadius() {
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
    profileImageView.clipsToBounds = true
  }
}
