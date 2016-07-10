//
//  SplashViewController.swift
//  OpenNA
//
//  Created by TeamSlogup on 2016. 6. 18..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData

// MARK : - PoliticsViewController : UIViewController

class SplashViewController: UIViewController {

    // MARK : - Property
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userDefaults : NSUserDefaults {
        return NSUserDefaults.standardUserDefaults()
    }
    
    var sharedContext:NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    // MARK : - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        preload()
        
        // Check whether there is any data exist in disk
        if userDefaults.boolForKey(Constants.UserDefaultKeys.InitialDataExist) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                
                self.performSegueWithIdentifier(Constants.Identifier.segueToTabVarVC, sender: self)
            }
        }
    }

    // MARK : - Load lawmaker information from JSON file
    
    func preload() {
        
        if !userDefaults.boolForKey(Constants.UserDefaultKeys.InitialDataExist) {
            activityIndicator.startAnimating()
            
            guard let pathForJSONData = NSBundle.mainBundle().pathForResource(Constants.Strings.SplashVC.BundleFileName, ofType: Constants.Strings.SplashVC.BundleFileType) else{
                #if DEBUG
                    log.debug("There is no data in your bundle")
                #endif
                return
            }
            
            guard let rawAJSONData = NSData(contentsOfFile:pathForJSONData) else {
                #if DEBUG
                    log.debug("Can not get a raw JSON data in \(pathForJSONData)")
                #endif
                return
            }
            
            let parsedResult:[[String:AnyObject]]!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(rawAJSONData, options: .AllowFragments) as! [[String:AnyObject]]
                
                #if DEBUG
                    log.debug("\(parsedResult)")
                #endif 
                
                for dict in parsedResult {
                    
                    guard let name = dict[Constants.JSONResponseKeys.NameEn] as? String else {
                        return
                    }
                    
                    guard let party = dict[Constants.JSONResponseKeys.Party] as? String else {
                        return
                    }
                    
                    guard let imageUrl = dict[Constants.JSONResponseKeys.Photo] as? String else {
                        return
                    }
                    
                    guard let birth = dict[Constants.JSONResponseKeys.Birth] as? String else {
                        return
                    }
                    
                    guard let district = dict[Constants.JSONResponseKeys.District] as? String else {
                        return
                    }
                    
                    guard let when_elected = dict[Constants.JSONResponseKeys.WhenElected] as? String else {
                        return
                    }
                    
                    guard let homepage = dict[Constants.JSONResponseKeys.Homepage] as? String else {
                        return
                    }
                    
                    var dictionary = [String:AnyObject]()
                    
                    dictionary[Constants.ModelKeys.NameEn] = name
                    dictionary[Constants.ModelKeys.ImageUrl] = imageUrl
                    dictionary[Constants.ModelKeys.Party] = party
                    dictionary[Constants.ModelKeys.Birth] = birth
                    dictionary[Constants.ModelKeys.Homepage] = homepage
                    dictionary[Constants.ModelKeys.WhenElected] = when_elected
                    dictionary[Constants.ModelKeys.District] = district
                    
                    let _ = Lawmaker(dictionary: dictionary, context: self.sharedContext)
                    
                    do {
                        
                        try sharedContext.save()
                        
                        // Set UserDefault as true, which implies data is already exist
                        userDefaults.setBool(true, forKey: Constants.UserDefaultKeys.InitialDataExist)
                        activityIndicator.stopAnimating()
                    } catch {
                        #if DEBUG
                            log.debug("\(error)")
                        #endif
                    }
                }
                
                
            } catch let error as NSError {
                #if DEBUG
                    let alertView = UIAlertController(title:"", message:error.localizedDescription, preferredStyle: .Alert)
                    alertView.addAction(UIAlertAction(title:Constants.Alert.Title.Dismiss, style:.Default, handler:nil))
                    self.presentViewController(alertView, animated: true, completion: nil)
                #endif
            }
        }
    }
    
}