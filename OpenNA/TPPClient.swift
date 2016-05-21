//
//  TPPClient.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import Alamofire


class TPPClient: NSObject {
    
    // MARK : Initializers
    override init() {
        super.init()
    }
    
    // MARK : GET
    func taskForGETMethod(parameters:[String:AnyObject], withPathExtension method:String ,completionHandlerForGet:(results:AnyObject?, error:NSError?)->Void)->NSURLSessionTask{
        
        
        let request = Alamofire.request(.GET, constructURL(parameters, withPathExtension:method), parameters: parameters)
            .responseJSON { response in
                
                switch response.result {
                    
                case .Success:
                    
                    if let results = response.result.value {
                        #if DEBUG
                            log.debug("response success")
                        #endif
                        completionHandlerForGet(results: results , error:nil)
                    }
                case .Failure(let error):
                    #if DEBUG
                        log.debug("response success")
                    #endif
                    completionHandlerForGet(results: nil, error: error)
                    
                }
        }
        
        return request.task
    }
    
    func taskForGetImage(url:NSURL, completionHandlerForImage : (imageData :NSData?, error:NSError?) ->Void )->NSURLSessionTask
    {
        
        let request = Alamofire.request(.GET, url)
            .responseData { response in
                
                
                switch response.result {
                    
                case .Success:
                    
                    if let result = response.data {
                        #if DEBUG
                            log.debug("response success")
                        #endif
                        completionHandlerForImage(imageData: result, error: nil)
                    }
                    
                case .Failure(let error):
                    #if DEBUG
                        log.debug("response success")
                    #endif
                    completionHandlerForImage(imageData: nil, error: error)
                    
                }
        }
        
        return request.task
    }
    
    // MARK: Helpers
    // Create a URL from parameters
    private func constructURL(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = Constants.Api.Scheme
        components.host = Constants.Api.Host
        components.path = Constants.Api.Path + (withPathExtension ?? "")
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        print("URL : \(String(components.URL))")
        return components.URL!
    }
    
    // MARK : Shared Instance (TPPClient Type)
    class func sharedInstance()->TPPClient {
        struct Singleton {
            static var sharedInstance = TPPClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK : Shared Instance (ImageCache Type)
    struct Caches {
        static let imageCache = ImageCache()
    }
    
}