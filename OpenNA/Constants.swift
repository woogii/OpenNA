//
//  TPPConstants.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

struct Constants {
    
    // MARK: API
    struct Api {
        
        // MARK: API Key
        static let Key    = "test"
        
        // MARK: URLs
        static let Scheme = "http"
        static let Host   = "api.popong.com"
        static let Path   = "/v0.1"
    }
    
    // MARK: TPP Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey  = "api_key"
        static let Sort    = "sort"
        static let PerPage = "per_page"
        static let Order   = "order"
        static let Query   = "q"
        static let SponsorSearch = "s"
        
    }

    // MARK: TPP Parameter Values
    struct ParameterValues {
        
        static let ProposedDate   = "proposed_date"
        static let Logo           = "logo"
        static let LimitPage      = "200"
        static let PartyLimitPage = "150"
        
    }
    
    // MARK: Methods
    struct Methods {
        
        static let Bill      = "/bill"
        static let Person    = "/person"
        static let Party     = "/party"
        static let Statement = "/statement"
        
        // MARK: Search
        static let Search = "/search"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode    = "status_code"
       
        // MARK : Lawmaker
        static let Name          = "name"
        static let NameEn        = "name_en"
        static let Photo         = "photo"
        static let ImageUrl      = "imageUrl"
        static let Party         = "party"
        static let Address       = "address"
        static let Education     = "education"
        static let Birthday      = "birthday"
        static let Homepage      = "homepage"
        static let Gender        = "gender"
        static let LawmakerItems = "items"
        static let Id            = "id"
        
        // MARK: Bill
        static let BillItems        = "items"
        static let BillSponsor      = "sponsor"
        static let BillDocUrl       = "document_url"
        static let BillProposedDate = "proposed_date"
        static let BillName         = "name"
        static let BillAssemblyID   = "assembly_id"
        static let BillDecisionDate = "decision_date"
        static let BillCoSponsors   = "cosponsors"
        static let BillStatus       = "status"
        static let BillID           = "id"
        static let BillSummary      = "summary"
        static let BillKind         = "kind"
        
        // MARK: Party
        static let PartyColor = "color"
        static let PartyLogo  = "logo"
        static let PartySize  = "size"
        static let PartyId    = "id"
        static let PartyName  = "name"
        
        
        static let NextPage   = "next_page"
    }
    
    // MARK : Fetch
    struct Fetch {
        static let FetchEntityLawmaker = "Lawmaker"
        static let SortKeyForLawmaker  = "name"
        static let PredicateForImage   = "imageUrl=%@"
    }
    
    // MARK : Cell Identifier
    struct Identifier {
        
        static let PeopleCell = "LawmakerCell"
        static let BillCell   = "BillCell"
        static let PartyCell  = "LogoImageCell"
        static let DetailStoryboardSegue = "showLawmaker"
        static let SearchResult = "searchResult"
    }

    // MARK : Activity Indicator Text 
    struct ActivityIndicatorText {
        
        static let Loading   = "Loading..."
        static let Searching = "Searching..."
    }
    
    // MARK : Error
    struct Error {
        
        static let DomainJSONParsing = "JSON Data Parsing"
        static let DomainSearchAll = "Search All"
        static let Code = 0
        static let DescKeyForLawmakerJSONParsing = "Could not parse Lawmaker type JSON"
        static let DescKeyForBillJSONParsing     = "Could not parse Bill type JSON "
        static let DescKeyForPartyJSONParsing    = "Could not parse Bill type JSON "
        static let DescKeyForNoSearchResult      = "Could not parse Bill type JSON "
    }
    
    // MARK : Section Name
    struct SectionName {
        
        static let Lawmaker = "lawmaker"
        static let Bill     = "bill"
        static let Party    = "party"
        
    }
    
    // MARK : Model Key
    struct ModelKeys {
    
        // MARK : Lawmaker
        static let Name = "name"
        static let ImageUrl = "imageUrl"
        static let Party    = "party"
        static let LawmakerEntity = "Lawmaker"
        
        // MARK : Bill
        static let BillSponsor = "sponsor"
        static let BillProposedDate = "proposed_date"
        static let BillName = "name"
        static let BillStatus = "status"
        static let BillSummary = "summary"
        
        // MARK: Party
        static let PartyColor = "color"
        static let PartyLogo  = "logo"
        static let PartySize  = "size"
        static let PartyId    = "id"
        static let PartyName  = "name"
    }
    
    static let UserDefaultsKey = "dataExist"
    static let BundleFileName = "assembly"
    static let BundleFileType = "json"
    static let LogFileName = "XCGLogger_Log.txt"
  
}