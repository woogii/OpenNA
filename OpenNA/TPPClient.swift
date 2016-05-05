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
            
                                //log.debug(response.request)  // original URL request
                                //log.debug(response.response) // URL response
                                //print(response.data)     // server data
                                //print(response.result)   // result of response serialization
                   
                    switch response.result {
            
                        case .Success:
        

                            if let results = response.result.value {
                                log.debug("response success")
                                completionHandlerForGet(results: results , error:nil)
                            }
                    case .Failure(let error):
                        log.debug("response success")
                        completionHandlerForGet(results: nil, error: error)
                
                    }
        }
        
        return request.task
    }
    
    func taskForGetImage(url:NSURL, completionHandlerForImage : (imageData :NSData?, error:NSError?) ->Void )->NSURLSessionTask
    {
        
        let request = Alamofire.request(.GET, url)
                               .responseData { response in
                
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
                
                                switch response.result {
                    
                                case .Success:
                    
                    
                                    if let result = response.data {
                                        log.debug("response success")
                                        completionHandlerForImage(imageData: result, error: nil)
                                    }
                    
                                case .Failure(let error):
                                    log.debug("response success")
                                    completionHandlerForImage(imageData: nil, error: error)
                    
                                }
        }
        
        return request.task
    }
    
    
    // MARK: Helpers
    
    // http://api.popong.com/v0.2/bill/?api_key=test

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
        print(String(components.URL))
        return components.URL!
    }
    
    // MARK : Shared Instance
    
    class func sharedInstance()->TPPClient {
        struct Singleton {
            static var sharedInstance = TPPClient()
        }
        return Singleton.sharedInstance
    }
    
    struct Caches {
        static let imageCache = ImageCache()
    }
    
}