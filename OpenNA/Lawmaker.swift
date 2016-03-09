//
//  Lawmaker.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 9..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import CoreData

class Lawmaker : NSManagedObject {
    
    @NSManaged var name:String?
    @NSManaged var imageUrl :String?
    @NSManaged var party:String?
    
}