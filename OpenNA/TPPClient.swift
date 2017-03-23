//
//  TPPClient.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

// MARK : - TPPClient : NSObject

class TPPClient: NSObject {
  
  
  // MARK : - Property
  
  let photoCache = AutoPurgingImageCache (
    memoryCapacity: 100 * 1024 * 1024,
    preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
  )
  
  // MARK : - Initialization
  
  override init() {
    super.init()
  }
  
  // MARK : - HTTP GET Request
  
  func taskForGETMethod(_ parameters:[String:AnyObject], withPathExtension method:String ,completionHandlerForGet:@escaping (_ results:AnyObject?, _ error:NSError?)->Void)->URLSessionTask{
    
    let request = Alamofire.request(constructURL(parameters, withPathExtension:method), parameters: parameters)
      .responseJSON { response in
        
        switch response.result {
          
        case .success:
          
          if let results = response.result.value {
            
            completionHandlerForGet(results as AnyObject? , nil)
          }
        case .failure(let error):
          
          completionHandlerForGet(nil, error as NSError?)
          
        }
    }
    
    return request.task!
  }
  
  func taskForGetImage(_ url:URL, completionHandlerForImage : @escaping (_ imageData :Data?, _ error:NSError?) ->Void )->URLSessionTask
  {
    
    let request = Alamofire.request(url).responseData { response in
      
      switch response.result {
        
      case .success:
        
        if let result = response.data {
          completionHandlerForImage(result, nil)
        }
        
      case .failure(let error):
        completionHandlerForImage(nil, error as NSError?)
      }
    }
    
    return request.task!
  }
  
  func taskForGetDirectImage(_ urlString:String, completionHandlerForImage : @escaping (_ image :UIImage?, _ error:NSError?) -> Void)->Request
  {
    
    return Alamofire.request(urlString)
      .responseImage { response in
        
        
        switch response.result {
          
        case .success:
          
          if response.result.value != nil {
            #if DEBUG
              print("response success")
            #endif
            //self.cacheImage(image, urlString: urlString)
            completionHandlerForImage(response.result.value, nil)
          }
          
        case .failure(let error):

          completionHandlerForImage(nil, error as NSError?)
          
        }
    }
    
  }
  
  // MARK : - Construct URL
  // Create a URL from parameters
  fileprivate func constructURL(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
    
    var components = URLComponents()
    components.scheme = Constants.Api.Scheme
    components.host = Constants.Api.Host
    components.path = Constants.Api.Path + (withPathExtension ?? "")
    components.queryItems = [URLQueryItem]()
    
    for (key, value) in parameters {
      
      let queryItem = URLQueryItem(name: key, value: "\(value)")
      components.queryItems!.append(queryItem)
    }
    #if DEBUG
      print("URL : \(String(describing: components.url))")
    #endif
    return components.url!
  }
  
  
  // MARK : - Shared Instance (TPPClient Type)
  class func sharedInstance()->TPPClient {
    struct Singleton {
      static var sharedInstance = TPPClient()
    }
    return Singleton.sharedInstance
  }
  
  // MARK : - Shared Instance (ImageCache Type)
  struct Caches {
    static let imageCache = ImageCache()
  }
  
}
