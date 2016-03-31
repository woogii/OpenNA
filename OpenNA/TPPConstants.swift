//
//  TPPConstants.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

extension TPPClient {
    
    
    // MARK: Constants
    struct Constants {
        // MARK: API Key
        static let ApiKey : String = "test"
        
        // MARK: URLs
        static let ApiScheme = "http"
        static let ApiHost = "api.popong.com"
        static let ApiPath = "/v0.1"
    }
    
    // MARK: TPP Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let Sort = "sort"
        static let Order = "order"
        static let Query = "q"
    }

    // MARK: TPP Parameter Values
    struct ParameterValues {
        static let ProposedDate = "proposed_date"
        static let Logo = "logo"
    }
    
    
    // http://api.popong.com/v0.2/bill/?api_key=test
    
    // MARK: Methods
    struct Methods {
        
        static let Bill = "/bill"
        static let Person = "/person"
        static let Party = "/party"
        static let Statement = "/statement"
        
        
        // MARK: Search
        static let Search = "/search"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Bill
        static let BillItems = "items"
        static let BillSponsor = "sponsor"
        static let BillDocUrl = "document_url"
        static let BillProposedDate = "proposed_date"
        static let BillName = "name"
        static let BillAssemblyID = "assembly_id"
        static let BillDecisionDate = "decision_date"
        static let BillCoSponsors = "cosponsors"
        static let BillStatus = "status"
        static let BillID = "id"
        static let BillSummary = "summary"
        static let BillKind = "kind"
        
        // MARK: Party
        static let PartyColor = "color"
        static let PartyLogo = "logo"
        static let PartySize = "size"
        static let PartyId = "id"
        static let PartyName = "name"
        
        
        static let NextPage = "next_page"
    }

}