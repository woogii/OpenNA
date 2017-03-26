//
//  LawmakerListViewController.swift
//  OpenNA
//
//  Created by TeamSlogup on 2016. 5. 28..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK : - LawmakerListViewController : UIViewController

class LawmakerListViewController : UIViewController {
  
  // MARK : - Property
  
  @IBOutlet weak var tableView: UITableView!
  var lawmakersInList = [LawmakerInList]()
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  let tableViewRowHeight:CGFloat = 140
  
  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    // Register Nib Objects
    registerNibFileForTableView()
    setDelegateAndDatasourceForTableView()
    getLawmakerList()
    
  }
  
  func registerNibFileForTableView() {
    tableView.register(UINib(nibName: Constants.Identifier.LawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.LawmakerCell)
  }
  
  func setDelegateAndDatasourceForTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  func getLawmakerList() {
    lawmakersInList = fetchLawmakersInList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    lawmakersInList = fetchLawmakersInList()
    tableView.reloadData()
  }
  
  // MARK : - Fetch Lawmakers In Favorite List
  
  func fetchLawmakersInList()->[LawmakerInList] {
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.LawmakerInList)
    
    do {
      return try sharedContext.fetch(fetchRequest) as! [LawmakerInList]
      
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
      return [LawmakerInList]()
    }
    
  }
  
  // MARK : - Prepare For Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let path = tableView.indexPathForSelectedRow {
      
      let detailVC = segue.destination as! LawmakerDetailViewController
      
      detailVC.pinnedImage = lawmakersInList[path.row].pinnedImage
      detailVC.name = lawmakersInList[path.row].name
      detailVC.birth = lawmakersInList[path.row].birth
      detailVC.party = lawmakersInList[path.row].party
      detailVC.when_elected = lawmakersInList[path.row].when_elected
      detailVC.district = lawmakersInList[path.row].district
      detailVC.homepage = lawmakersInList[path.row].homepage
      detailVC.image = lawmakersInList[path.row].image
      detailVC.pinnedImage = lawmakersInList[path.row].pinnedImage
      detailVC.hidesBottomBarWhenPushed = true
      
    }
  }
  
  @IBAction func pushBackButton(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
  }
  
}

// MARK : - LawmakerListViewController : UITableViewDelegate, UITableViewDataSource

extension LawmakerListViewController : UITableViewDelegate, UITableViewDataSource {
  
  // MARK : - UITableViewDataSource Methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    var numberOfSection = 0
    
    if lawmakersInList.count > 0 {
      
      self.tableView.backgroundView = nil
      numberOfSection = 1
      
      
    } else {
      
      let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
      noDataLabel.text = Constants.Strings.LawmakerListVC.DefaultLabelMessage
      noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
      noDataLabel.textAlignment = NSTextAlignment.center
      self.tableView.backgroundView = noDataLabel
      
    }
    
    return numberOfSection
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.LawmakerCell, for: indexPath) as! LawmakerTableViewCell
    configureCell(cell, atIndexPath: indexPath)
    return cell
  }
  
  func configureCell(_ cell:LawmakerTableViewCell , atIndexPath indexPath:IndexPath)
  {
    
    cell.nameLabel.text = lawmakersInList[indexPath.row].name
    cell.partyLabel.text = lawmakersInList[indexPath.row].party
    let urlString:String? = lawmakersInList[indexPath.row].image
    let url = URL(string: urlString!)!
    
    var pinnedImage:UIImage?
    cell.imageView!.image = nil
    
    if  lawmakersInList[indexPath.row].pinnedImage != nil {
      #if DEBUG
        print("images exist")
      #endif
      pinnedImage = lawmakersInList[indexPath.row].pinnedImage
    }
    else {
      
      let task = RestClient.sharedInstance().taskForGetImage(url) { data, error  in
        
        if let data = data {
          
          let image = UIImage(data : data)
          
          DispatchQueue.main.async {
            self.lawmakersInList[indexPath.row].pinnedImage = image
            cell.profileImageView!.image = image
          }
        } else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
        }
        
      }
      
      cell.taskToCancelifCellIsReused = task
    }
    
    cell.profileImageView!.image = pinnedImage
    
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return lawmakersInList.count
  }
  
  // MARK : UITableView Delegate Methods
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewRowHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: Constants.Identifier.LawmakerDetailVC, sender: self)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  
}
