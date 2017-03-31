//
//  TPPConstants.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation

// MARK : - Constants

struct Constants {
  
  // MARK : - API
  
  struct Api {
    
    // MARK: - API Key
    
    static let Key    = "test"
    
    // MARK: - URLs
    
    static let Scheme = "http"
    static let Host   = "api.popong.com"
    static let Path   = "/v0.1"
  }
  
  // MARK: - TPP Parameter Keys
  
  struct ParameterKeys {
    
    static let ApiKey  = "api_key"
    static let Sort    = "sort"
    static let PerPage = "per_page"
    static let Order   = "order"
    static let Query   = "q"
    static let SponsorSearch = "s"
    static let Page = "page"
    
  }
  
  // MARK: - TPP Parameter Values
  
  struct ParameterValues {
    
    static let ProposedDate   = "proposed_date"
    static let Logo           = "logo"
    static let LimitPage      = "20"
    static let PartyLimitPage = "150"
    
  }
  
  // MARK: - Methods
  
  struct Methods {
    
    static let Bill      = "/bill"
    static let Person    = "/person"
    static let Party     = "/party"
    static let Statement = "/statement"
    
    // MARK : - Search
    
    static let Search = "/search"
    
  }
  
  // MARK : - JSON Response Keys
  
  struct JSONResponseKeys {
    
    // MARK : - General
    
    static let StatusMessage = "status_message"
    static let StatusCode    = "status_code"
    static let Items         = "items"
    
    // MARK : - Lawmaker
    
    static let Name          = "name_kr"
    static let NameEn        = "name_en"
    static let Photo         = "photo"
    static let ImageUrl      = "image"
    static let Party         = "party"
    static let Address       = "address"
    static let Education     = "education"
    static let Birth         = "birth"
    static let Homepage      = "homepage"
    static let Gender        = "gender"
    static let Id            = "id"
    static let WhenElected   = "when_elected"
    static let District      = "district"
    
    // MARK : - Bill
    
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
    
    // MARK : - Party
    
    static let PartyColor = "color"
    static let PartyLogo  = "logo"
    static let PartySize  = "size"
    static let PartyId    = "id"
    static let PartyName  = "name"
    
    // MARK : - Common
    
    static let NextPage   = "next_page"
  }
  
  // MARK : - Fetch
  
  struct Fetch {
    
    static let SortKeyForLawmaker  = "name"
    static let PredicateForImage   = "image=%@"
    static let PredicateForName    = "name=%@"
    
  }
  
  // MARK : - Entity
  
  struct Entity {
    
    static let Lawmaker = "Lawmaker"
    static let LawmakerInList = "LawmakerInList"
    static let BillInList = "BillInList"
  }
  
  // MARK : - Cell & Segue Identifier
  
  struct Identifier {
    
    static let LawmakerCell       = "LawmakerCell"
    static let BillCell         = "BillCell"
    static let PartyImageCell   = "LogoImageCell"
    static let SearchedResultCell = "SearchResultCell"
    static let SearchResult     = "searchResult"
    static let SearchedLawmakerCell = "SearchedLawmakerCell"
    static let SearchedBillCell = "SearchedBillCell"
    static let SearchedPartyCell = "SearchedPartyCell"
    static let BirthCell      = "birthCell"
    static let PartyCell      = "partyCell"
    static let InOfficeCell   = "inOfficeCell"
    static let DistrictCell   = "districtCell"
    static let HomepageCell   = "homepageCell"
    static let LawmakerDetailCell = "lawmakerDetailCell"
    static let SearchedLawmakerDetailCell = "searchedLawmakerDetailCell"
    static let BillDetailInfoTableViewCell = "billDetailInfoTableViewCell"
    
    static let segueToWebViewVC = "showWebView"
    static let segueToTabVarVC = "ShowTabBarVC"
    static let LawmakerDetailVC = "LawmakerDetail"
    static let BillDetailVC = "BillDetail"
    static let SearchedLawmakerDetailVC = "SearchedLawmakerDetail"
    static let WebViewVC = "webViewVC"
    
  }
  
  // MARK : - Activity Indicator Text
  
  struct ActivityIndicatorText {
    
    static let Loading   = "Loading..."
    static let Searching = "Searching..."
  }
  
  // MARK : - Error
  
  struct Error {
    
    static let DomainJSONParsing = "JSON Data Parsing"
    static let DomainSearchAll = "Search All"
    static let Code = 0
    static let DescKeyForLawmakerJSONParsing = "Could not parse Lawmaker type JSON"
    static let DescKeyForBillJSONParsing     = "Could not parse Bill type JSON "
    static let DescKeyForPartyJSONParsing    = "Could not parse Bill type JSON "
    static let DescKeyForNoSearchResult      = "There is no search results"
  }
  
  // MARK : - Section Name
  
  struct SectionName {
    
    static let Lawmaker = "국회의원"//"lawmaker"
    static let Bill     = "의안"//"bill"
    static let Party    = "정당"//"party"
    
  }
  
  // MARK : - Model Key
  
  struct ModelKeys {
    
    // MARK : - Lawmaker
    
    static let Name = "name"
    static let NameEn = "name_en"
    static let ImageUrl = "image"
    static let Party    = "party"
    static let Birth    = "birth"
    static let Homepage = "homepage"
    static let WhenElected = "when_elected"
    static let District = "district"
    static let Address = "address"
    static let Blog = "blog"
    static let Education = "education"
    static let LawmakerEntity = "Lawmaker"
    
    // MARK : - Bill
    
    static let BillSponsor = "sponsor"
    static let BillProposedDate = "proposed_date"
    static let BillName = "name"
    static let BillStatus = "status"
    static let BillSummary = "summary"
    static let BillDocumentUrl = "documentUrl"
    static let BillAssemblyId = "assemblyId"
    
    // MARK : - Party
    
    static let PartyColor = "color"
    static let PartyLogo  = "logo"
    static let PartySize  = "size"
    static let PartyId    = "id"
    static let PartyName  = "name"
    
  }
  
  // MARK : - Custom Cell
  
  struct CustomCell {
    
    static let PartyLabel    = "Party"
    static let BirthLabel    = "Birth"
    static let InOfficeLabel = "In Office"
    static let DistrictLabel = "District"
    static let HomepageLabel = "Homepage"
    static let BlogLabel     = "Blog"
    static let AddressLabel  = "Address"
    static let EducationLabel  = "Education"
    
    static let PartyLabelKr     = "정당"
    static let BirthLabelKr     = "출생"
    static let InOfficeLabelKr  = "의원대수"
    static let DistrictLabelKr  = "지역구"
    static let HomepageLabelKr  = "웹사이트"
    static let BlogLabelKr      = "블로그"
    static let AddressLabelKr   = "주소"
    static let EducationLabelKr = "학력"
  }
  
  // MARK : - Default System Key
  
  struct UserDefaultKeys {
    static let InitialDataExist = "InitialData"
  }
  
  // MARK : - Alert
  
  struct Alert {
    
    struct Title {
      static let OK = "OK"
      static let Dismiss = "Dismiss"
      static let Cancel = "Cancel"
    }
    
    struct Message {
      static let WebPageLoadingFail = "There was a problem loading the web page!"
    }
    
  }
  
  // MARK : Strings
  struct Strings {
    
    struct LawmakerDetailVC {
      
      static let NumOfProfileCells = 5
      static let HeaderTitle = "Profile"
      
    }
    
    struct SearchedLawmakerDetailVC {
      
      static let defaultImageName = "noImage"
      
    }
    
    struct PoliticsVC {
      static let WikiUrl = "https://ko.wikipedia.org/wiki/"
      static let PartyPlaceholder = "img_party_placeholder"
    }
    
    struct SplashVC {
      static let BundleFileName = "assembly"
      static let BundleFileType = "json"
    }
    
    struct SearchVC {
      static let WikiUrl = "https://ko.wikipedia.org/wiki/"
      static let defaultImageName = "img_profile_placeholder"
      static let PartyPlaceholder = "img_party_placeholder"
      static let DefaultLabelMessage = "검색어를 입력하세요.(인물,법안,정당 키워드)"
      static let NoSearchResultMessage = "검색 결과가 존재하지 않습니다."
    }
    
    struct Party {
      static let imageTextFont = "Helvetica Bold"
      static let partyImageUrl = "http://data.popong.com/parties/images/"
      static let partyImageExtension = ".png"
      static let defaultImageName = "noImage"
    }
    
    struct LawmakerListVC {
      static let DefaultLabelMessageKr = "현재 목록이 없습니다."
    }
    
    struct BillListVC {
      static let DefaultLabelMessageKr =  "현재 목록이 없습니다."
    }
    
    struct BillDetailVC {
      static let TextViewDefaultMsgKr = "요약 준비중"
      static let AssemblyIdTitle = "국회 대수"
      static let ProposeDateTitle = "제안일자"
      static let StatusTitle = "상태"
      static let SponsorTitle = "발의자"
      static let ExtenalLinkTitle = "외부링크"
    }
    
    struct WebVC {
      static let Title = "의안 원문 PDF"
    }
  }
  
  struct Images {
    static let FavoriteIconEmpty = "ic_favorite_empty"
    static let FavoriteIconFilled = "ic_favorite_filled"
  }
  
  struct Title {
    struct Button {
      static let OK = "Done"
      static let Dismiss = "Dismiss"
    }
  }
  
}
