//
//  Enums.swift
//  OpenNA
//
//  Created by siwook on 2017. 3. 25..
//  Copyright © 2017년 wook2. All rights reserved.
//

import Foundation

// MARK : - LawmakerDetailInfoType : Int

enum LawmakerDetailInfoType:Int {
  case birth=0,party,inOffice,district,homepage
}

// MARK : - BillDetailInfoType : Int

enum BillDetailInfoType : Int {
  case assemblyId=0,proposeDate,status,sponsor,externalLink
}

// MARK : - SegmentedControlType : Int

enum SegmentedControlType:Int {
  case lawmaker=0,bill,party
}



