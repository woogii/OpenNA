//
//  PartyCollectionViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 31..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - PartyCollectionViewCell : UICollectionViewCell

class PartyCollectionViewCell : UICollectionViewCell {
  
  // MARK : Property
  
  @IBOutlet weak var logoImageView: UIImageView!
  
  var taskToCancelifCellIsReused: URLSessionTask? {
    
    didSet {
      if let taskToCancel = oldValue {
        taskToCancel.cancel()
      }
    }
  }
  
}
