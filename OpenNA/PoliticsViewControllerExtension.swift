//
//  PoliticsViewControllerExtension.swift
//  OpenNA
//
//  Created by TeamSlogup on 2017. 3. 30..
//  Copyright © 2017년 wook2. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

// MARK : - PoliticsViewController : UITableViewDelegate, UITableViewDataSource

extension PoliticsViewController : UITableViewDelegate, UITableViewDataSource {
    
  // MARK : - UITableView DataSource Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var count = 0
    
    switch segmentedControl.selectedSegmentIndex {
      
    case SegmentedControlType.lawmaker.rawValue:
      count = indexInfo[section].1.count
      break
    case SegmentedControlType.bill.rawValue :
      count = bills.count
      break
    default:
      break
    }
    
    return count
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return segmentedControl.selectedSegmentIndex == 0 ? indexInfo.count : 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return segmentedControl.selectedSegmentIndex == 0 ? String(indexInfo[section].0): nil
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return segmentedControl.selectedSegmentIndex == 0 ? indexInfo.map({String($0.0)}):[String]()
  }
  
  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return index
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if segmentedControl.selectedSegmentIndex == SegmentedControlType.lawmaker.rawValue {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.LawmakerCell, for: indexPath) as! LawmakerTableViewCell
      configurLawmakerCell(cell, atIndexPath: indexPath)
      return cell
    }
    else if segmentedControl.selectedSegmentIndex == SegmentedControlType.bill.rawValue {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.BillCell, for: indexPath) as! BillTableViewCell
      
      cell.nameLabel.text = bills[indexPath.row].name
      cell.sponsorLabel.text = bills[indexPath.row].sponsor
      cell.statusLabel.text = bills[indexPath.row].status
      
      return cell
    }
    
    return UITableViewCell()
  }
  
  // MARK : - Congifure UITableviewCell
  
  func configurLawmakerCell(_ cell:LawmakerTableViewCell , atIndexPath indexPath:IndexPath)
  {
    setNameLabel(cell: cell, indexPath: indexPath)
    setPartyLabel(cell: cell, indexPath: indexPath)
    setDistrictLabel(cell: cell, indexPath: indexPath)
    setProfileImage(cell: cell, indexPath: indexPath)
  }
  
  func setNameLabel(cell:LawmakerTableViewCell, indexPath: IndexPath) {
    cell.nameLabel.text = indexInfo[indexPath.section].1[indexPath.row].name
  }
  
  func setPartyLabel(cell:LawmakerTableViewCell, indexPath: IndexPath) {
    cell.partyLabel.text = indexInfo[indexPath.section].1[indexPath.row].party
  }
  
  func setDistrictLabel(cell:LawmakerTableViewCell, indexPath: IndexPath) {
    let district = indexInfo[indexPath.section].1[indexPath.row].district ?? ""
    if district.characters.count <= maximumDisctirctCharCount {
      cell.districtLabel.text = district
    } else {
      cell.districtLabel.text = district.substring(to: district.index(district.startIndex, offsetBy: 6))
    }
  }
  
  
  func setProfileImage(cell:LawmakerTableViewCell, indexPath: IndexPath) {
    
    let urlString:String = indexInfo[indexPath.section].1[indexPath.row].image ?? ""
    let url = URL(string: urlString)!
    
    let searchedLawmaker = CoreDataHelper.fetchLawmaker(from:urlString)
    
    var pinnedImage:UIImage?
    cell.imageView!.image = nil
    
    if  searchedLawmaker.pinnedImage != nil {
      #if DEBUG
        print("images exist")
      #endif
      pinnedImage = searchedLawmaker.pinnedImage
    }
    else {
      
      let task = RestClient.sharedInstance().taskForGetImage(url) { data, error  in
        
        if let data = data {
          
          let image = UIImage(data : data)
          
          DispatchQueue.main.async {
            
            searchedLawmaker.pinnedImage = image
            
            UIView.transition(with: cell.profileImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
              cell.profileImageView!.image = image
            }, completion: nil)
            
          }
        }
      }
      
      cell.taskToCancelifCellIsReused = task
    }
    
    cell.profileImageView!.image = pinnedImage
    
  }
  
  // MARK : - UITableView Delegate Methods
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case SegmentedControlType.lawmaker.rawValue :
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.LawmakerDetailVC) as! LawmakerDetailViewController
      controller.lawmaker = indexInfo[indexPath.section].1[indexPath.row]
      controller.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(controller, animated: true)
      break
      
    case SegmentedControlType.bill.rawValue :
      
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.BillDetailVC) as! BillDetailViewController
      controller.bill = bills[indexPath.row]
      controller.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(controller, animated: true)
      break
    default:
      break
    }
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

// MARK: - PoliticsViewController: UICollectionDelegate, UICollectionViewDataSource

extension PoliticsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
  
  // MARK : - UICollectionViewDataSource Methods
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return parties.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.PartyImageCell, for: indexPath) as! PartyCollectionViewCell
    
    configureCollectionViewCell(cell: cell, indexPath: indexPath)
    
    return cell
  }
  
  func configureCollectionViewCell(cell:PartyCollectionViewCell, indexPath:IndexPath) {
    
    let urlString =  Constants.Strings.Party.partyImageUrl + String(parties[indexPath.row].id) + Constants.Strings.Party.partyImageExtension
    
    _ = RestClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
      
      if let image = image {
        DispatchQueue.main.async {
          self.parties[indexPath.row].thumbnail = image
          cell.logoImageView?.image = image
          cell.partyNameLabel.isHidden = true
        }
      } else {
        
        DispatchQueue.main.async {
          let defaultImage = UIImage(named:Constants.Strings.PoliticsVC.PartyPlaceholder)
          cell.logoImageView.image = defaultImage
          cell.partyNameLabel.text = self.parties[indexPath.row].name
          cell.partyNameLabel.isHidden = false
        }
      }
    }
  }
  
  // MARK : - UICollectionViewDelegate Methods
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.WebViewVC) as! WebViewController
    
    controller.urlString = Constants.Strings.SearchVC.WikiUrl + parties[indexPath.row].name
    controller.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(controller, animated: true)
    
  }
}

// MARK : - PoliticsViewController : UICollectionViewDelegateFlowLayout

extension PoliticsViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = floor(self.collectionView.frame.size.width/numberOfRowsForPartyCollectionView)
    return CGSize(width: width, height: width - valueForAdjustPartyCellHeight)
  }
}


// MARK : - PoliticsViewController : UIScrollViewDelegate

extension PoliticsViewController : UIScrollViewDelegate {
  
  // MARK: - UIScrollViewDelegate
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    // check whether scroll is available
    if scrollView.contentSize.height > scrollView.frame.size.height {
      
      // if scroll point is at the end of the screen
      if scrollView.bounds.origin.y + scrollView.frame.size.height >= scrollView.contentSize.height {
        
        if !isRequesting && !isLastPage {
          
          isRequesting = true
          loadBills()
        }
        
      }
    }
  }
  
  func loadBills() {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case SegmentedControlType.bill.rawValue:
      
      let spinActivity = MBProgressHUD.showAdded(to: view, animated: true)
      spinActivity.label.text = Constants.ActivityIndicatorText.Loading
      
      RestClient.sharedInstance().getBills(PoliticsViewController.page) { (bills, error) in
        
        spinActivity.hide(animated:true)
        
        if let addedbills = bills {
          
          if addedbills.count == 0 {
            self.isLastPage = true
            return
          }
          self.bills.append(contentsOf: addedbills)
          self.isRequesting = false
          
          DispatchQueue.main.async  {
            self.tableView.reloadData()
            
          }
        }
        else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
        }
      }
      
    default:
      break
      
    }
    
  }
}
