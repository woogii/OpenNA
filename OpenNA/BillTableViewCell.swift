//
//  BillTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 30..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - BillTableViewCell : Custom TableViewCell

class BillTableViewCell:UITableViewCell{
    
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var billImage: UIImageView!
    @IBOutlet weak var sponsorImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    //@IBOutlet weak var backgroundCardView: UIView!
    @IBOutlet weak var backgroundCardView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCardView.backgroundColor = UIColor.whiteColor()
        contentView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        backgroundCardView.layer.cornerRadius = 3.0
        backgroundCardView.layer.masksToBounds = false
        backgroundCardView.layer.shadowColor = UIColor.blackColor().colorWithAlphaComponent(0.2).CGColor
        backgroundCardView.layer.shadowOffset = CGSizeMake(0, 0)
        backgroundCardView.layer.shadowOpacity = 0.8
        
    }

}