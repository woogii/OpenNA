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
    /// Get bill information
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
                    completionHandler(results: nil, error: NSError(domain: Constants.Error.DomainJSONParsing, code : Constants.Error.Code,
                        userInfo:[NSLocalizedDescriptionKey:Constants.Error.DescKeyForBillJSONParsing]))
                }
            }
            
        }
    }
    
    /// Get party information
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
                    completionHandler(results: nil, error: NSError(domain: Constants.Error.DomainJSONParsing, code : Constants.Error.Code,
                        userInfo:[NSLocalizedDescriptionKey:Constants.Error.DescKeyForPartyJSONParsing]))
                }
            }
            
        }
    }
    
    /// Get lawmaker information
    func searchLawmaker( searchKeyword: String, completionHandler: (results:[[String:AnyObject]]?, error:NSError?)->Void)->NSURLSessionTask {
        
        let method = Constants.Methods.Person + Constants.Methods.Search
        var parameters = [Constants.ParameterKeys.Query:searchKeyword]
        parameters[Constants.ParameterKeys.ApiKey] = Constants.Api.Key
        
        
        let task = taskForGETMethod( parameters, withPathExtension: method) { (requestResult, error) in
            
            if let error = error {
                completionHandler(results:nil, error:error)
            }
            else {
                
                if let results = requestResult![Constants.JSONResponseKeys.LawmakerItems] as? [[String:AnyObject]] {
                    completionHandler(results: results, error: nil)
                } else {
                    completionHandler(results:  nil, error:NSError(domain: Constants.Error.DomainJSONParsing, code: 0,
                        userInfo: [NSLocalizedDescriptionKey:Constants.Error.DescKeyForLawmakerJSONParsing]))
                }
            }
        }
        
        return task
    }
    
    /// Search bill information with given search keyword
    func searchBills( searchKeyword: String, completionHandler:(results:[Bill]?, error:NSError?)->Void)->NSURLSessionTask {
        
        let method = Constants.Methods.Bill + Constants.Methods.Search
        var parameters = [Constants.ParameterKeys.Query : searchKeyword]
        
        parameters[Constants.ParameterKeys.ApiKey] = Constants.Api.Key
        
        let task = taskForGETMethod(parameters, withPathExtension: method) { (requestResult, error) in
            
            if let error = error  {
                completionHandler(results:nil, error:error)
            }
            else {
                
                if let results = requestResult![Constants.JSONResponseKeys.BillItems] as? [[String:AnyObject]] {
                    let bills = Bill.billsFromResults(results)
                    completionHandler(results: bills, error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: Constants.Error.DomainJSONParsing, code : 0,
                        userInfo:[NSLocalizedDescriptionKey:Constants.Error.DescKeyForBillJSONParsing]))
                }
            }
            
        }
        
        return task
    }
    
    /// Search party information with given search keyword
    func searchParties( searchKeyword: String, completionHandler:(results:[Party]?, error:NSError?)->Void)->NSURLSessionTask {
        
        let method = Constants.Methods.Party + Constants.Methods.Search
        var parameters = [Constants.ParameterKeys.Query : searchKeyword]
        
        parameters[Constants.ParameterKeys.ApiKey] = Constants.Api.Key
        
        let request = taskForGETMethod(parameters, withPathExtension: method) { (requestResult, error) in
            
            if let error = error  {
                completionHandler(results:nil, error:error)
            }
            else {
                
                if let results = requestResult![Constants.JSONResponseKeys.BillItems] as? [[String:AnyObject]] {
                    let parties = Party.partiesFromResults(results)
                    
                    completionHandler(results: parties, error: nil)
                } else {
                    completionHandler(results: nil, error: NSError(domain: Constants.Error.DomainJSONParsing, code : 0,
                        userInfo:[NSLocalizedDescriptionKey:Constants.Error.DescKeyForPartyJSONParsing]))
                }
            }
            
        }
        
        return request
    }
    
}