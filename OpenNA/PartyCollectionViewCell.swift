//
//  PartyCollectionViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 31..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class PartyCollectionViewCell : UICollectionViewCell {
 
    
    @IBOutlet weak var logoImageView: UIImageView!

    var taskToCancelifCellIsReused: NSURLSessionTask? {
        
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
}