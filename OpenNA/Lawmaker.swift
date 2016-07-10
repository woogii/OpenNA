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

// MARK : - Lawmaker : NSManagedObject 

class Lawmaker : NSManagedObject {

    // MARK : Property
    
    @NSManaged var name:String?
    @NSManaged var image:String?
    @NSManaged var party:String?
    @NSManaged var birth:String?
    @NSManaged var homepage:String?
    @NSManaged var when_elected:String?
    @NSManaged var district:String?
    @NSManaged var blog:String?
    @NSManaged var address:String?
    @NSManaged var education:String?
    
    var pinnedImage: UIImage? {
        
        get {
            let url = NSURL(fileURLWithPath: image!)
            let fileName = url.lastPathComponent
            return TPPClient.Caches.imageCache.imageWithIdentifier(fileName!)
            
        }
        
        set {
            let url = NSURL(fileURLWithPath: image!)
            let fileName = url.lastPathComponent
            TPPClient.Caches.imageCache.storeImage(newValue, withIdentifier: fileName!)
            
        }
    }

    // MARK : Initialization 
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity:entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary :[String:AnyObject], context: NSManagedObjectContext?)
    {
        let entity = NSEntityDescription.entityForName(Constants.Entity.Lawmaker, inManagedObjectContext: context!)
        
        super.init(entity : entity!, insertIntoManagedObjectContext: context)
        
        name         = dictionary[Constants.ModelKeys.NameEn] as? String
        image        = dictionary[Constants.ModelKeys.ImageUrl] as? String
        party        = dictionary[Constants.ModelKeys.Party] as? String
        birth        = dictionary[Constants.ModelKeys.Birth] as? String
        homepage     = dictionary[Constants.ModelKeys.Homepage] as? String
        when_elected = dictionary[Constants.ModelKeys.WhenElected] as? String
        district     = dictionary[Constants.ModelKeys.District] as? String
        blog         = dictionary[Constants.ModelKeys.Blog] as? String
        address      = dictionary[Constants.ModelKeys.Address] as? String
        education    = dictionary[Constants.ModelKeys.Education] as? String
    }

}