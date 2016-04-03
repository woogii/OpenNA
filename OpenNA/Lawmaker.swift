//
//  Lawmaker.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 9..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Lawmaker : NSManagedObject {
    @NSManaged var name:String?
    @NSManaged var imageUrl :String?
    @NSManaged var party:String?

    var pinnedImage: UIImage? {
        
        get {
            let url = NSURL(fileURLWithPath: imageUrl!)
            let fileName = url.lastPathComponent
            return TPPClient.Caches.imageCache.imageWithIdentifier(fileName!)
            
        }
        
        set {
            let url = NSURL(fileURLWithPath: imageUrl!)
            let fileName = url.lastPathComponent
            TPPClient.Caches.imageCache.storeImage(newValue, withIdentifier: fileName!)
            
        }
    }

}