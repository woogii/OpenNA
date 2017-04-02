//
//  SearchedPartyTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 5. 23..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

// MARK : - SearchedPartyTableViewCell: UITableViewCell

class SearchedPartyTableViewCell: UITableViewCell {
  
  // MARK : - Property
  
  @IBOutlet weak var partyImageView: UIImageView!
  @IBOutlet weak var partyLabel: UILabel!
  
  var partyInfo: Party! {
    didSet {
      updateCell()
    }
  }
  
  fileprivate func updateCell() {
    
    partyLabel.text = partyInfo.name

    if partyInfo.logo == ""  {
      partyImageView!.image = UIImage(named:Constants.Strings.SearchVC.PartyPlaceholder)
    }
    
    guard let urlString = partyInfo.logo else {
      return
    }
    
    _ = RestClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
      
      if let image = image {
        DispatchQueue.main.async {
          self.partyImageView?.image = image
        }
      }
    }
  }
  
  
}
