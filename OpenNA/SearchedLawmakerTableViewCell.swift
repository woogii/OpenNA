//
//  SearchedLawmakerTableViewCell.swift
//  OpenNA
//
//  Created by Hyun on 2016. 5. 23..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit

// MARK : - SearchedLawmakerTableViewCell : UITableViewCell

class SearchedLawmakerTableViewCell: UITableViewCell {
  
  // MARK : - Property
  
  @IBOutlet weak var lawmakerImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  var lawmakerInfo: Lawmaker! {
    didSet {
      updateCell()
    }
  }
  
  // MARK : - Initialization
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setLawmakerImageViewCornerRadius()
  }
  
  func setLawmakerImageViewCornerRadius() {
    lawmakerImageView.layer.cornerRadius = lawmakerImageView.frame.size.width/2
    lawmakerImageView.clipsToBounds = true
  }
  
  fileprivate func updateCell() {
    
    nameLabel?.text = lawmakerInfo.name
    

    guard let urlString = lawmakerInfo.image else {
      lawmakerImageView.image = UIImage(named:Constants.Strings.SearchVC.defaultImageName)
      return
    }
    
    _ = RestClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
    
      if let image = image {
        
        self.lawmakerInfo.pinnedImage = image
        DispatchQueue.main.async {
          self.lawmakerImageView?.image = image
        }
      }
    }
  }
  
}
