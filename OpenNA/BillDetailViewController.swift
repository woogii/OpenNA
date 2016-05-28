//
//  BillDetailViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 5. 15..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

class BillDetailViewController: UITableViewController {
    
    @IBOutlet weak var assembylIDLabel: UILabel!
    @IBOutlet weak var proposedDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var sponsorLabel: UILabel!
    @IBOutlet weak var documentURLLabel: UILabel!
    @IBOutlet weak var summaryTextView: UITextView!
    
    var bill:Bill?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        proposedDateLabel.text = bill?.proposeDate
        statusLabel.text = bill?.status
        sponsorLabel.text = bill?.sponsor
        documentURLLabel.text = bill?.documentUrl
        summaryTextView.text = bill?.summary
        
        guard let assemblyID = bill?.assemblyId  else {
            assembylIDLabel.text = ""
            return
        }
        
        assembylIDLabel.text = "\(assemblyID)"
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Identifier.segueToHomepageVC {
            let controller = segue.destinationViewController as! WebViewController
            controller.urlString = bill?.documentUrl
            controller.hidesBottomBarWhenPushed = true
        }
    }
    
    
}
