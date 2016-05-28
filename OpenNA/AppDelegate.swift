//
//  AppDelegate.swift
//  OpenNA
//
//  Created by Hyun on 2016. 2. 16..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import XCGLogger
import MBProgressHUD


let log: XCGLogger = {
    
    // Setup XCGLogger
    let log = XCGLogger.defaultInstance()
    log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
    log.xcodeColors = [
        .Verbose: .lightGrey,
        .Debug: XCGLogger.XcodeColor(fg: (255, 255, 100), bg: (0, 0, 0)),
        .Info: .darkGreen,
        .Warning: .orange,
        .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
        .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
    ]
    
    #if DEBUG // Set via Build Settings, under Other Swift Flags
        log.removeLogDestination(XCGLogger.Constants.baseConsoleLogDestinationIdentifier)
        log.addLogDestination(XCGNSLogDestination(owner: log, identifier: XCGLogger.Constants.nslogDestinationIdentifier))
        log.logAppDetails()
    #else
        let logPath: NSURL = (UIApplication.sharedApplication().delegate as! AppDelegate).cacheDirectory.URLByAppendingPathComponent(Constants.LogFileName)
        log.setup(.Debug, showThreadName: true, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)
    #endif
    
    return log
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK : Properties
    var window: UIWindow?
    var splashView: UIView?
    
    let cacheDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    
    let documentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.makeKeyAndVisible()
       
        preload()
        return true
    }
    
    func preload() {
        
        let ud = NSUserDefaults.standardUserDefaults()
        
        if !ud.boolForKey(Constants.UserDefaultsKey) {
            
            let activityIndicator = MBProgressHUD.showHUDAddedTo(window, animated: true)
            activityIndicator.labelText = Constants.ActivityIndicatorText.Loading
            
            guard let pathForJSONData = NSBundle.mainBundle().pathForResource(Constants.BundleFileName, ofType: Constants.BundleFileType) else{
                #if DEBUG
                    print("There is no data in your bundle")
                #endif
                return
            }
            
            guard let rawAJSONData = NSData(contentsOfFile:pathForJSONData) else {
                #if DEBUG
                    print("Can not get a raw JSON data in \(pathForJSONData)")
                #endif
                return
            }
            
            let parsedResult:[[String:AnyObject]]!
            
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(rawAJSONData, options: .AllowFragments) as! [[String:AnyObject]]
                
                print(parsedResult)
                
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
                    
                    dictionary[Constants.ModelKeys.Name] = name
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
                        ud.setBool(true, forKey: Constants.UserDefaultsKey)
                    } catch {
                        print(error)
                    }
                }
                activityIndicator.hide(true)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }

    }
    
    var sharedContext:NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
    
    
}

