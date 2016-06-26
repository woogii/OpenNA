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

// MARK : XCGLogger constant variable 
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
        
        return true
    }
    
      
    
}

