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

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        preload()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func preload() {
       
        let ud = NSUserDefaults.standardUserDefaults()

        if !ud.boolForKey("dataExist") {
            
            print("data exist")
            guard let pathForJSONData = NSBundle.mainBundle().pathForResource("assembly", ofType: "json") else{
                print("There is not a data in your bundle")
                return
            }
        
            guard let rawAJSONData = NSData(contentsOfFile:pathForJSONData) else {
                print("Can not get a raw JSON data in \(pathForJSONData)")
                return
            }
        
            let parsedResult:[[String:AnyObject]]!
        
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(rawAJSONData, options: .AllowFragments) as! [[String:AnyObject]]
            
                print(parsedResult)
        
                for dict in parsedResult {
                
                    guard let name = dict["name_en"] as? String else {
                        return
                    }
                
                    guard let party = dict["party"] as? String else {
                        return
                    }
                
                    guard let url = dict["photo"] as? String else {
                        return
                    }
                
                    let lawmaker = NSEntityDescription.insertNewObjectForEntityForName("Lawmaker", inManagedObjectContext: sharedContext) as! Lawmaker
                    
                    lawmaker.name = name
                    lawmaker.party = party
                    lawmaker.imageUrl = url
                
                    do {
                        try sharedContext.save()
                        // Set UserDefault as true, which implies data is already exist 
                        ud.setBool(true, forKey: "dataExist")
                    } catch {
                        print(error)
                    }
                }
        
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }

  
    var sharedContext:NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }
}

