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
        static let ApiPath = "/v0.2"
    }
    
    // MARK: TPP Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
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
        

        // MARK: Movies
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        
    }

}