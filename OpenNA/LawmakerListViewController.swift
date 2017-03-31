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
    registerNibFileForTableView()
  }
  
  func registerNibFileForTableView() {
    tableView.register(UINib(nibName: Constants.Identifier.LawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.LawmakerCell)
  }
  
  func getLawmakerList() {
    lawmakersInList = fetchLawmakersInList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
    getLawmakerList()
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
      
      detailVC.lawmaker = CoreDataHelper.fetchLawmaker(from: lawmakersInList[path.row].image ?? "")
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
      noDataLabel.text = Constants.Strings.LawmakerListVC.DefaultLabelMessageKr
      noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
      noDataLabel.textAlignment = NSTextAlignment.center
      self.tableView.backgroundView = noDataLabel
      
    }
    
    return numberOfSection
  }
  
 
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.LawmakerCell, for: indexPath) as! LawmakerTableViewCell
    cell.lawmakerInListInfo = lawmakersInList[indexPath.row]
    
    return cell
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
