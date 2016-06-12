//
//  PeopleTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 10..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - LawmakerTableViewCell : Custom TableViewCell

class LawmakerTableViewCell : TaskCancelingTableViewCell {
    
    // MARK : Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var backgroundCardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileImageView.clipsToBounds = true
        
    
        backgroundCardView.backgroundColor = UIColor.whiteColor()
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
        backgroundCardView.layer.shadowOffset = CGSizeMake(0, 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }
}