//
//  PeopleTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 10..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - BillTableViewCell : Custom TableViewCell

class PeopleTableViewCell : TaskCancelingTableViewCell {
    
    // MARK : Properties
    @IBOutlet weak var peopleImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
}