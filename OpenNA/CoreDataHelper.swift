//
//  CoreDataHelper.swift
//  OpenNA
//
//  Created by TeamSlogup on 2017. 3. 30..
//  Copyright © 2017년 wook2. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// MARK : - CoreDataHelper : NSObject

class CoreDataHelper: NSObject {

  // MARK : - Fetch Lawmakers in Favorite List
  
  class func fetchLawmakerInList(name:String?, image:String?)->[LawmakerInList]? {
   
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
    
    // Fetch a single lawmaker with given name and image
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.LawmakerInList)
    let firstPredicate = NSPredicate(format: Constants.Fetch.PredicateForName, name ?? "")
    let secondPredicate = NSPredicate(format: Constants.Fetch.PredicateForImage, image ?? "")
    let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates:[firstPredicate,secondPredicate])
    fetchRequest.predicate = compoundPredicate
    
    // In order to fetch a single object
    fetchRequest.fetchLimit = 1
  
    var fetchedResults : [LawmakerInList]?
    
    do {
      fetchedResults = try sharedContext.fetch(fetchRequest) as? [LawmakerInList]
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
    }
    
    #if DEBUG
      print("fetch result : \(fetchedResults)")
    #endif
    
    return fetchedResults
  }
  
  class func fetchLawmaker(from imageUrl:String)->Lawmaker {
    
    let sharedContext = CoreDataStackManager.sharedInstance().managedObjectContext!
    
    /*
     Fetch a lawmaker by using a given imageUrl string to check whether an image is cached
     If an image is not cahced, http request function is invoked to download an image
     */
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.Lawmaker )
    let predicate = NSPredicate(format: Constants.Fetch.PredicateForImage, imageUrl)
    fetchRequest.predicate = predicate
    
    // In order to fetch a single object
    fetchRequest.fetchLimit = 1
    
    var lawmaker:Lawmaker!
    var fetchedResults:[Lawmaker]!

    do {
      fetchedResults =  try sharedContext.fetch(fetchRequest) as! [Lawmaker]
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
    }
    // Get a single fetched object

    lawmaker = fetchedResults.first ?? Lawmaker()
    
    return lawmaker
  }
}
