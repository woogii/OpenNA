//
//  ViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 2. 16..
//  Copyright © 2016년 wook2. All rights reserved.
//

import UIKit
import Foundation


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var lawmakers = [String]()
    let cellIdentifier = "cell"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lawmakers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        cell.detailTextLabel!.text = lawmakers[indexPath.row]
        
        return cell
    }
    
    func loadData() {
        
        guard let pathForJSONData = NSBundle.mainBundle().pathForResource("assembly", ofType: "json") else{
            print("There is not a data in your bundle")
            return
        }
        
        guard let rawAJSONData = NSData(contentsOfFile:pathForJSONData) else {
            print("Can not get a raw JSON data in \(pathForJSONData)")
            return
        }
        
        let parsedResult:[[String:AnyObject]]!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(rawAJSONData, options: .AllowFragments) as! [[String:AnyObject]]
            
            print(parsedResult.count)
            
            for dict in parsedResult {
                //print(dict)
                guard let name = dict["name_kr"] as? String else {
                    print("test")
                    return
                }
                lawmakers.append(name)
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
        
    }
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        
    }
    
    
}

