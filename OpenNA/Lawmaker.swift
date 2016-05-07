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
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity:entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary :[String:AnyObject], context: NSManagedObjectContext?)
    {
        let entity = NSEntityDescription.entityForName(Constants.ModelKeys.LawmakerEntity, inManagedObjectContext: context!)
        
        super.init(entity : entity!, insertIntoManagedObjectContext: context)
        
        name = dictionary[Constants.ModelKeys.Name] as? String
        imageUrl = dictionary[Constants.ModelKeys.ImageUrl] as? String
        party = dictionary[Constants.ModelKeys.Party] as? String
    }

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