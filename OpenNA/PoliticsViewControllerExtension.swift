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
    
    if tableView == lawmakerTableView {
      let lawmakers = indexInfo[section].1
      return lawmakers.count

    } else {
      return bills.count
    }
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return tableView == lawmakerTableView ? indexInfo.count : 1
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return tableView == lawmakerTableView ? String(indexInfo[section].0): nil
  }
  
  func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return tableView == lawmakerTableView ? indexInfo.map({String($0.0)}):[String]()
  }
  
  func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
    return index
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if tableView == lawmakerTableView {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.LawmakerCell, for: indexPath) as! LawmakerTableViewCell
      cell.lawmakerInfo = indexInfo[indexPath.section].1[indexPath.row]
      return cell
    } else {
    
      let cell = billTableView.dequeueReusableCell(withIdentifier: Constants.Identifier.BillCell, for: indexPath) as! BillTableViewCell
      cell.billInfo = bills[indexPath.row]
      
      return cell
    }
    
  }
  
  // MARK : - UITableView Delegate Methods
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if tableView == lawmakerTableView {
      
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.LawmakerDetailVC) as! LawmakerDetailViewController
      controller.lawmaker = indexInfo[indexPath.section].1[indexPath.row]
      controller.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(controller, animated: true)
    
    } else if tableView == billTableView {
    
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.BillDetailVC) as! BillDetailViewController
      controller.bill = bills[indexPath.row]
      controller.hidesBottomBarWhenPushed = true
      navigationController?.pushViewController(controller, animated: true)
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
    cell.partyInfo = parties[indexPath.row]
    return cell
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
      
      PoliticsViewController.page += 1
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
            self.billTableView.reloadData()
            
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
