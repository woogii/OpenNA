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
  
   init(name:String,imageUrl:String,party:String,birth:String,homepage:String,when_elected:String,
        district:String,blog:String?=nil,address:String?=nil,education:String?=nil, context: NSManagedObjectContext)
  {
    let entity = NSEntityDescription.entity(forEntityName: Constants.Entity.Lawmaker, in: context)
    
    super.init(entity : entity!, insertInto: context)
    
    self.name         = name
    self.image        = imageUrl
    self.party        = party
    self.birth        = birth
    self.homepage     = homepage
    self.when_elected = when_elected
    self.district     = district
    self.blog         = blog
    self.address      = address
    self.education    = education
  }
  
  
  init(dictionary :[String:AnyObject], context: NSManagedObjectContext) {
    
    let entity = NSEntityDescription.entity(forEntityName: Constants.Entity.Lawmaker, in: context)
    super.init(entity : entity!, insertInto: context)

    name         = dictionary[Constants.ModelKeys.Name] as? String
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
