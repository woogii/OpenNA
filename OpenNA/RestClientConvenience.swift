//
//  TPPClientConvenience.swift
//  OpenNA
//
//  Created by Hyun on 2016. 5. 5..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

extension RestClient {
  
  // MARK : - Convenience Methods
  /// Get bill information
  func getBills(_ page:Int, completionHandler: @escaping (_ results:[Bill]?, _ error:NSError?)->Void)  {
    
    let method = Constants.Methods.Bill
    var parameters = [Constants.ParameterKeys.ApiKey:Constants.Api.Key]
    parameters[Constants.ParameterKeys.Sort] = Constants.ParameterValues.ProposedDate
    parameters[Constants.ParameterKeys.PerPage] = Constants.ParameterValues.LimitPage
    parameters[Constants.ParameterKeys.Page] = "\(page)"
    
    _ = taskForGETMethod(parameters as [String : AnyObject], withPathExtension: method) { (requestResult, error) in
      
      if let error = error  {
        completionHandler(nil, error)
      }
      else {
        
        if let results = requestResult![Constants.JSONResponseKeys.Items] as? [[String:AnyObject]] {
          let bills = Bill.billsFromResults(results)
          completionHandler(bills, nil)
        } else {
          completionHandler(nil, NSError(domain: Constants.Error.DomainJSONParsing, code : Constants.Error.Code,
                                                         userInfo:[NSLocalizedDescriptionKey:Constants.Error.DescKeyForBillJSONParsing]))
        }
      }
      
    }
  }
  
  /// Get party information
  func getParties( _ completionHandler: @escaping (_ results:[Party]?, _ error:NSError?)->Void)  {
    
    let method = Constants.Methods.Party
    var parameters = [Constants.ParameterKeys.ApiKey:Constants.Api.Key]
    parameters[Constants.ParameterKeys.Sort] = Constants.ParameterValues.Logo
    parameters[Constants.ParameterKeys.PerPage] = Constants.ParameterValues.PartyLimitPage
    
    _ = taskForGETMethod(parameters as [String : AnyObject], withPathExtension: method) { (requestResult, error) in
      
      if let error = error  {
        completionHandler(nil, error)
      }
      else {
        
        if let results = requestResult![Constants.JSONResponseKeys.Items] as? [[String:AnyObject]] {
          
          let parties = Party.partiesFromResults(results)
          #if DEBUG
            print("\(parties)")
          #endif
          completionHandler(parties, nil)
        } else {
          completionHandler(nil, NSError(domain: Constants.Error.DomainJSONParsing, code : Constants.Error.Code,
                                                         userInfo:[NSLocalizedDescriptionKey:Constants.Error.DescKeyForPartyJSONParsing]))
        }
      }
      
    }
  }
  
  /// Get lawmaker information
  func searchLawmaker( _ searchKeyword: String, completionHandler: @escaping (_ results:[[String:AnyObject]]?, _ error:NSError?)->Void)->URLSessionTask {
    
    let method = Constants.Methods.Person + Constants.Methods.Search
    var parameters = [Constants.ParameterKeys.Query:searchKeyword]
    parameters[Constants.ParameterKeys.ApiKey] = Constants.Api.Key
    
    
    let task = taskForGETMethod( parameters as [String : AnyObject], withPathExtension: method) { (requestResult, error) in
      
      if let error = error {
        completionHandler(nil, error)
      }
      else {
        
        if let results = requestResult![Constants.JSONResponseKeys.Items] as? [[String:AnyObject]] {
          completionHandler(results, nil)
        } else {
          completionHandler(nil, NSError(domain: Constants.Error.DomainJSONParsing, code: 0,
                                                         userInfo: [NSLocalizedDescriptionKey:Constants.Error.DescKeyForLawmakerJSONParsing]))
        }
      }
    }
    
    return task
  }
  
  /// Search bill information with given search keyword
  func searchBills( _ searchKeyword: String, completionHandler:@escaping (_ results:[Bill]?, _ error:NSError?)->Void)->URLSessionTask {
    
    let method = Constants.Methods.Bill + Constants.Methods.Search
    var parameters = [Constants.ParameterKeys.Query : searchKeyword]
    
    parameters[Constants.ParameterKeys.ApiKey] = Constants.Api.Key
    
    let task = taskForGETMethod(parameters as [String : AnyObject], withPathExtension: method) { (requestResult, error) in
      
      if let error = error  {
        completionHandler(nil, error)
      }
      else {
        
        if let results = requestResult![Constants.JSONResponseKeys.Items] as? [[String:AnyObject]] {
          let bills = Bill.billsFromResults(results)
          completionHandler(bills, nil)
        } else {
          completionHandler(nil, NSError(domain: Constants.Error.DomainJSONParsing, code : 0,
                                                         userInfo:[NSLocalizedDescriptionKey:Constants.Error.DescKeyForBillJSONParsing]))
        }
      }
      
    }
    
    return task
  }
  
  /// Search party information with given search keyword
  func searchParties( _ searchKeyword: String, completionHandler:@escaping (_ results:[Party]?, _ error:NSError?)->Void)->URLSessionTask {
    
    let method = Constants.Methods.Party + Constants.Methods.Search
    var parameters = [Constants.ParameterKeys.Query : searchKeyword]
    
    parameters[Constants.ParameterKeys.ApiKey] = Constants.Api.Key
    
    let request = taskForGETMethod(parameters as [String : AnyObject], withPathExtension: method) { (requestResult, error) in
      
      if let error = error  {
        completionHandler(nil, error)
      }
      else {
        
        if let results = requestResult![Constants.JSONResponseKeys.Items] as? [[String:AnyObject]] {
          let parties = Party.partiesFromResults(results)
          
          completionHandler(parties, nil)
        } else {
          completionHandler(nil, NSError(domain: Constants.Error.DomainJSONParsing, code : 0,
                                                         userInfo:[NSLocalizedDescriptionKey:Constants.Error.DescKeyForPartyJSONParsing]))
        }
      }
      
    }
    
    return request
  }
  
}
