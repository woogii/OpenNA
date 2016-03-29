//
//  TPPClient.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

class TPPClient: NSObject {
    
    
    // MARK : Properties
    
    // shared session
    var session = NSURLSession.sharedSession()

    
    // MARK : Initializers
    
    override init() {
        super.init()
    }
    
    // MARK : GET 
    
    func taskForGETMethod()->NSURLSessionDataTask{
    
        /* 1. Set the parameters */
        let parameters = [ParameterKeys.ApiKey:Constants.ApiKey]
        let method = Methods.Bill
        
        let request = NSMutableURLRequest(URL:constructURL(parameters, withPathExtension:method))
        
        let task = session.dataTaskWithRequest(request) { (data,response, error) in
            
            func displayError(error:String) {
                print(error)
            }
        
            guard (error == nil) else {
                displayError("error")
                return
            }
            
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                displayError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                displayError("No data was returned by the request")
                return
            }
        }
        
        task.resume()
        
        return task
    }
    
    func taskForImage(url:NSURL, completionHandler : (data :NSData?, response:NSURLResponse?, error:NSError?) ->Void )->NSURLSessionTask
    {
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {   data,response,error in
            
            if let error = error  {
                print("\(error.description)")
                completionHandler(data: data,response: response, error: error)
            }
            else {
                completionHandler(data: data,response: response, error: error)
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    // MARK: Helpers
    
    
    
    // http://api.popong.com/v0.2/bill/?api_key=test

    // Create a URL from parameters
    private func constructURL(parameters: [String:AnyObject], withPathExtension: String? = nil) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = TPPClient.Constants.ApiScheme
        components.host = TPPClient.Constants.ApiHost
        components.path = TPPClient.Constants.ApiPath + Methods.Bill
        components.queryItems = [NSURLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.URL!
    }
    
    // MARK : Shared Instance
    
    class func sharedInstance()->TPPClient {
        struct Singleton {
            static var sharedInstance = TPPClient()
        }
        return Singleton.sharedInstance
    }
    
}