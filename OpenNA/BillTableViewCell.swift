//
//  BillTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 30..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class BillTableViewCell:UITableViewCell{
    
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
//    http://stackoverflow.com/questions/7817284/ios-draw-circle-like-in-calendar-app
//    override func init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        
//        var context:CGContextRef = UIGraphicsGetCurrentContext()!
//        
//        CGContextSetFillColorWithColor(context, self.color)
//        CGContextSetAlpha(context, 0.5);
//        CGContextFillEllipseInRect(context, CGRectMake(10.0, 10.0, 10.0, 10.0));
//        
//        CGContextSetStrokeColorWithColor(context, self.color);
//        CGContextStrokeEllipseInRect(context, CGRectMake(10.0, 10.0, 10.0, 10.0));
//    }
}