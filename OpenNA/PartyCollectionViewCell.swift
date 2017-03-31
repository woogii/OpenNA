//
//  PartyCollectionViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 3. 31..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - PartyCollectionViewCell : UICollectionViewCell

class PartyCollectionViewCell : UICollectionViewCell {
  
  // MARK : Property
  
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var partyNameLabel: UILabel!
  
  var partyInfo : Party! {
    didSet {
      updateCell()
    }
  }
  
  lazy var defaultImage : UIImage = {
    let image = UIImage(named:Constants.Strings.PoliticsVC.PartyPlaceholder)
    return image!
  }()
  
  fileprivate func updateCell() {
    
    let urlString =  Constants.Strings.Party.partyImageUrl + String(partyInfo.id) + Constants.Strings.Party.partyImageExtension
    
    _ = RestClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
      
      if image != nil {
        
        DispatchQueue.main.async {
          self.partyInfo.thumbnail = image
          self.logoImageView?.image = self.partyInfo.thumbnail
          self.partyNameLabel.isHidden = true
        }
      } else {
        
        DispatchQueue.main.async {
          
          self.logoImageView.image = self.defaultImage
          self.partyNameLabel.text = self.partyInfo.name
          self.partyNameLabel.isHidden = false
        }
      }
    }

  }
}
