//
//  TaskCancelingTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 10..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class TaskCancelingTableViewCell : UITableViewCell {
    
    var taskToCancelifCellIsReused : NSURLSessionTask? {
        
        // Property Observer
        didSet {
            
            if let oldtask = oldValue {
                print("cancel")
                oldtask.cancel()
            }
            
        }
    }
    
}


