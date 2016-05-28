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

class LawmakerListViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var lawmakers = [LawmakerInList]()
    
    
    override func viewWillAppear(animated: Bool) {
        
        
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.LawmakerInList)
    

    }
    
    override func viewDidLoad() {
        // Register Nib Objects
        tableView.registerNib(UINib(nibName: Constants.Identifier.PeopleCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.PeopleCell)
       
        

    }
    
    
}

extension LawmakerListViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
}