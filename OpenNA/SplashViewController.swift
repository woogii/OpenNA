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
  
  var userDefaults : UserDefaults {
    return UserDefaults.standard
  }
  var sharedContext:NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    super.viewDidAppear(animated)
    preload()
    
    // Check whether there is any data exist in disk
    if userDefaults.bool(forKey: Constants.UserDefaultKeys.InitialDataExist) {
      
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
        
        self.performSegue(withIdentifier: Constants.Identifier.segueToTabVarVC, sender: self)
      }
    }
  }
  
  // MARK : - Load lawmaker information from JSON file
  
  func preload() {
    
    if !userDefaults.bool(forKey: Constants.UserDefaultKeys.InitialDataExist) {
      activityIndicator.startAnimating()
      
      guard let pathForJSONData = Bundle.main.path(forResource: Constants.Strings.SplashVC.BundleFileName, ofType: Constants.Strings.SplashVC.BundleFileType) else{
        #if DEBUG
          print("There is no data in your bundle")
        #endif
        return
      }
      
      guard let rawAJSONData = try? Data(contentsOf: URL(fileURLWithPath: pathForJSONData)) else {
        #if DEBUG
          print("Can not get a raw JSON data in \(pathForJSONData)")
        #endif
        return
      }
      
      let parsedResult:[[String:AnyObject]]!
      
      do {
        parsedResult = try JSONSerialization.jsonObject(with: rawAJSONData, options: .allowFragments) as! [[String:AnyObject]]
        
        #if DEBUG
          print("\(parsedResult)")
        #endif
        
        for dict in parsedResult {
          
          let name = dict[Constants.JSONResponseKeys.NameEn] as? String ?? ""
          let party = dict[Constants.JSONResponseKeys.Party] as? String ?? ""
          let imageUrl = dict[Constants.JSONResponseKeys.Photo] as? String ?? ""
          let birth = dict[Constants.JSONResponseKeys.Birth] as? String ?? ""
          let district = dict[Constants.JSONResponseKeys.District] as? String ?? ""
          let when_elected = dict[Constants.JSONResponseKeys.WhenElected] as? String ?? ""
          let homepage = dict[Constants.JSONResponseKeys.Homepage] as? String ?? ""
         
      
          let _ = Lawmaker(name: name, imageUrl: imageUrl, party: party, birth: birth, homepage: homepage, when_elected: when_elected, district: district, context: sharedContext)
          
          do {
            
            try sharedContext.save()
            
            // Set UserDefault as true, which implies data is already exist
            userDefaults.set(true, forKey: Constants.UserDefaultKeys.InitialDataExist)
            activityIndicator.stopAnimating()
          } catch {
            #if DEBUG
              print("\(error)")
            #endif
          }
        }
        
        
      } catch let error as NSError {
        #if DEBUG
          let alertView = UIAlertController(title:"", message:error.localizedDescription, preferredStyle: .alert)
          alertView.addAction(UIAlertAction(title:Constants.Alert.Title.Dismiss, style:.default, handler:nil))
          self.present(alertView, animated: true, completion: nil)
        #endif
      }
    }
  }
  
}
