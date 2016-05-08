//
//  LawmakerDetailViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 4. 2..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK: - LawmakerDetailViewController : UIViewController

class LawmakerDetailViewController: UIViewController {
    
    // MARK : Properties

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var lawmaker:Lawmaker? 
    var image:UIImage?
    
    // MARK : View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewWillAppear(animated: Bool) {
        log.debug("test")
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        profileImage.image = image 
        //nameLabel.text = lawmaker?.name
        //profileImage.image = UIImage(named:(lawmaker?.imageUrl)!)
    }
    
    
    
}