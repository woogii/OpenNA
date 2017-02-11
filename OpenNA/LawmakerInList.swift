//
//  LawmakersInList.swift
//  OpenNA
//
//  Created by TeamSlogup on 2016. 5. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// MARK : - LawmakersInList : NSManagedObject

class LawmakerInList : NSManagedObject {
  
  // MARK : Property
  
  @NSManaged var name:String?
  @NSManaged var image:String?
  @NSManaged var party:String?
  @NSManaged var birth:String?
  @NSManaged var homepage:String?
  @NSManaged var when_elected:String?
  @NSManaged var district:String?
  
  var pinnedImage: UIImage? {
    
    get {
      let url = URL(fileURLWithPath: image!)
      let fileName = url.lastPathComponent
      return TPPClient.Caches.imageCache.imageWithIdentifier(fileName)
      
    }
    
    set {
      let url = URL(fileURLWithPath: image!)
      let fileName = url.lastPathComponent
      TPPClient.Caches.imageCache.storeImage(newValue, withIdentifier: fileName)
      
    }
  }
  
  // MARK : Initialization
  
  override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity:entity, insertInto: context)
  }
  
  init(dictionary :[String:AnyObject], context: NSManagedObjectContext?)
  {
    let entity = NSEntityDescription.entity(forEntityName: Constants.Entity.LawmakerInList , in: context!)
    
    super.init(entity : entity!, insertInto: context)
    
    name         = dictionary[Constants.ModelKeys.NameEn] as? String
    image        = dictionary[Constants.ModelKeys.ImageUrl] as? String
    party        = dictionary[Constants.ModelKeys.Party] as? String
    birth        = dictionary[Constants.ModelKeys.Birth] as? String
    homepage     = dictionary[Constants.ModelKeys.Homepage] as? String
    when_elected = dictionary[Constants.ModelKeys.WhenElected] as? String
    district     = dictionary[Constants.ModelKeys.District] as? String
    
  }
  
}
