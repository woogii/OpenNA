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
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity:entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary :[String:AnyObject], context: NSManagedObjectContext?)
    {
        let entity = NSEntityDescription.entityForName(Constants.Entity.BillInList, inManagedObjectContext: context!)
        
        super.init(entity : entity!, insertIntoManagedObjectContext: context)
        
        name         = dictionary[Constants.ModelKeys.BillName] as? String
        proposeDate  = dictionary[Constants.ModelKeys.BillProposedDate] as? String
        sponsor      = dictionary[Constants.ModelKeys.BillSponsor] as? String
        status       = dictionary[Constants.ModelKeys.BillStatus] as? String
        summary      = dictionary[Constants.ModelKeys.BillSummary] as? String
        documentUrl  = dictionary[Constants.ModelKeys.BillDocumentUrl] as? String
        assemblyId   = dictionary[Constants.ModelKeys.BillAssemblyId] as? Int
        
    }
    
}