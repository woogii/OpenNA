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
      return RestClient.Caches.imageCache.imageWithIdentifier(fileName)
      
    }
    
    set {
      let url = URL(fileURLWithPath: image!)
      let fileName = url.lastPathComponent
      RestClient.Caches.imageCache.storeImage(newValue, withIdentifier: fileName)
      
    }
  }
  
  // MARK : Initialization
  
  override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity:entity, insertInto: context)
  }
  
  init(name:String?,image:String?, party:String?, birth:String?, homepage:String?, when_elected:String?, district:String?, context: NSManagedObjectContext?)
  {
    let entity = NSEntityDescription.entity(forEntityName: Constants.Entity.LawmakerInList , in: context!)
    
    super.init(entity : entity!, insertInto: context)
    
    self.name         = name
    self.image        = image
    self.party        = party
    self.birth        = birth
    self.homepage     = homepage
    self.when_elected = when_elected
    self.district     = district
    
  }
  
}
