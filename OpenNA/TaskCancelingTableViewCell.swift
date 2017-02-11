//
//  TaskCancelingTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 10..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - TaskCancelingTableViewCell : UITableViewCell

class TaskCancelingTableViewCell : UITableViewCell {
  
  // MARK : - Property Observer
  
  var taskToCancelifCellIsReused : URLSessionTask? {
    
    didSet {
      
      if let oldtask = oldValue {
        oldtask.cancel()
      }
    }
  }
  
}


