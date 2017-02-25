//
//  BillsInList.swift
//  OpenNA
//
//  Created by TeamSlogup on 2016. 5. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import CoreData

// MARK : - BillsInList : NSManangedObject

class BillInList : NSManagedObject {
  
  // MARK : Property
  
  @NSManaged var name:String?
  @NSManaged var proposeDate:String?
  @NSManaged var sponsor:String?
  @NSManaged var status:String?
  @NSManaged var summary:String?
  @NSManaged var documentUrl:String?
  @NSManaged var assemblyId:NSNumber?
  
  // MARK : Initialization
  
  override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
    super.init(entity:entity, insertInto: context)
  }
  
  init(name:String?, proposedDate:String?,sponsor:String?, status:String?, summary:String?, documentUrl:String?, assemblyID:Int?, context: NSManagedObjectContext?)
  {
    let entity = NSEntityDescription.entity(forEntityName: Constants.Entity.BillInList, in: context!)
    
    super.init(entity : entity!, insertInto: context)
    
    self.name         = name
    self.proposeDate  = proposedDate
    self.sponsor      = sponsor
    self.status       = status
    self.summary      = summary
    self.documentUrl  = documentUrl
    self.assemblyId   = assemblyID as NSNumber?
    
  }
  
}
