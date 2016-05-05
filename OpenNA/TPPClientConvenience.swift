//
//  TPPClientConvenience.swift
//  OpenNA
//
//  Created by Hyun on 2016. 5. 5..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

extension TPPClient {
    
    
    // MARK : Convenience Methods
    
    func getBills(completionHandler: (results:[Bill]?, error:NSError?)->Void)  {
        
        let method = Constants.Methods.Bill
        var parameters = [Constants.ParameterKeys.ApiKey:Constants.Api.Key]
        parameters[Constants.ParameterKeys.Sort] = Constants.ParameterValues.ProposedDate
        parameters[Constants.ParameterKeys.PerPage] = Constants.ParameterValues.LimitPage
        
        taskForGETMethod(parameters, withPathExtension: method) { (requestResult, error) in
            
            if let error = error  {
                completionHandler(results:nil, error:error)
            }
            else {
                
                if let results = requestResult![Constants.JSONResponseKeys.BillItems] as? [[String:AnyObject]] {
                    let bills = Bill.billsFromResults(results)
                    completionHandler(results: bills, error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: "getBills parsing", code : 0,
                        userInfo:[NSLocalizedDescriptionKey:"Could not parse getBills"]))
                }
            }
            
        }
    }
    
    func getParties( completionHandler: (results:[Party]?, error:NSError?)->Void)  {
        
        let method = Constants.Methods.Party
        var parameters = [Constants.ParameterKeys.ApiKey:Constants.Api.Key]
        parameters[Constants.ParameterKeys.Sort] = Constants.ParameterValues.Logo
        parameters[Constants.ParameterKeys.PerPage] = Constants.ParameterValues.PartyLimitPage
        
        taskForGETMethod(parameters, withPathExtension: method) { (requestResult, error) in
            
            if let error = error  {
                completionHandler(results:nil, error:error)
            }
            else {
                
                if let results = requestResult![Constants.JSONResponseKeys.BillItems] as? [[String:AnyObject]] {
                    let parties = Party.partiesFromResults(results)
                    
                    completionHandler(results: parties, error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: "getBills parsing", code : 0,
                        userInfo:[NSLocalizedDescriptionKey:"Could not parse getBills"]))
                }
            }
            
        }
    }
    
    
    
    
    func searchLawmaker( searchKeyword: String, completionHandler: (results:[[String:AnyObject]]?, error:NSError?)->Void)->NSURLSessionTask {
        
        // curl "http://api.popong.com/v0.1/person/search?q=박&api_key=test"
        // curl "http://api.popong.com/v0.1/bill/search?q=데이터&s=김영환&api_key=test"
        // curl "http://api.popong.com/v0.1/party/search?q=통합&api_key=test"
        
        
        let method = Constants.Methods.Person
        var parameters = [Constants.ParameterKeys.ApiKey:Constants.Api.Key]
        parameters[Constants.ParameterKeys.Query] = searchKeyword
        
        let task = taskForGETMethod( parameters, withPathExtension: method) { (requestResult, error) in
            
            if let error = error {
                completionHandler(results:nil, error:error)
            }
            else {
                
                if let results = requestResult![Constants.JSONResponseKeys.LawmakerItems] as? [[String:AnyObject]] {
                    completionHandler(results: results, error: nil)
                } else {
                    completionHandler(results:  nil, error:NSError(domain: "search people", code: 0,
                        userInfo: [NSLocalizedDescriptionKey:"Could not parse results of searchPeople"]))
                }
            }
        }
        
        return task
    }
    
    func searchBills( searchKeyword: String, completionHandler:(results:[Bill]?, error:NSError?)->Void)->NSURLSessionTask {
        
        let method = Constants.Methods.Bill + Constants.Methods.Search
        var parameters = [Constants.ParameterKeys.ApiKey:Constants.Api.Key]
        
        parameters[Constants.ParameterKeys.Query] = searchKeyword
        
        let task = taskForGETMethod(parameters, withPathExtension: method) { (requestResult, error) in
            
            if let error = error  {
                completionHandler(results:nil, error:error)
            }
            else {
                
                if let results = requestResult![Constants.JSONResponseKeys.BillItems] as? [[String:AnyObject]] {
                    let bills = Bill.billsFromResults(results)
                    completionHandler(results: bills, error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: "getBills parsing", code : 0,
                        userInfo:[NSLocalizedDescriptionKey:"Could not parse getBills"]))
                }
            }
            
        }
        
        return task
    }
    
    func searchParties( searchKeyword: String, completionHandler:(results:[Party]?, error:NSError?)->Void)->NSURLSessionTask {
        
        let method = Constants.Methods.Party
        var parameters = [Constants.ParameterKeys.ApiKey:Constants.Api.Key]
        parameters[Constants.ParameterKeys.Query] = searchKeyword
        
        
        let request = taskForGETMethod(parameters, withPathExtension: method) { (requestResult, error) in
            
            if let error = error  {
                completionHandler(results:nil, error:error)
            }
            else {
                
                if let results = requestResult![Constants.JSONResponseKeys.BillItems] as? [[String:AnyObject]] {
                    let parties = Party.partiesFromResults(results)
                    
                    completionHandler(results: parties, error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: "getBills parsing", code : 0,
                        userInfo:[NSLocalizedDescriptionKey:"Could not parse getBills"]))
                }
            }
            
        }
        
        return request
    }
    
    
    
}