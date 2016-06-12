//
//  SearchedLawmakerTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 5. 23..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

class SearchedLawmakerTableViewCell: UITableViewCell {

    @IBOutlet weak var lawmakerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lawmakerImageView.layer.cornerRadius = lawmakerImageView.frame.size.width/2
        lawmakerImageView.clipsToBounds = true
    }
}
