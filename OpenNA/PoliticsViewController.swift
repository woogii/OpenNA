//
//  ViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 2. 16..
//  Copyright © 2016년 wook2. All rights reserved.
//
import UIKit
import Foundation
import CoreData
import MBProgressHUD

// MARK: - PoliticsViewController : UIViewController

class PoliticsViewController: UIViewController  {

    // MARK : Properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var lawmakers:[Lawmaker]!
    var bills:[Bill]!
    var parties = [Party]()
    
    struct LawmakerInfo {
        var name : String
        var party : String
        var imageUrl:String
    }
    
    var lawmakerInfo = [LawmakerInfo]()

    typealias Entry = (Character, [LawmakerInfo])

    var indexInfo = [Entry]()
    
    struct cellIdentifier {
        static let PeopleCell = "LawmakerCell"
        static let BillCell = "BillCell"
        static let PartyCell = "LogoImageCell"
    }
    
    // MARK :  View Life Cycle
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        // Lay out the collection view so that cells take up 1/3 of the width,
        // with no space in between
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = floor(self.collectionView.frame.size.width/3)
        layout.itemSize = CGSize(width: width, height: width)
        collectionView.collectionViewLayout = layout
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        configureLayout()
        
        lawmakers = fetchAllLawmakers()
        
        buildTableViewIndex()
    }
    
    

    
    func configureLayout() {
        
        // Register Nib Objects
        self.tableView.registerNib(UINib(nibName: cellIdentifier.PeopleCell, bundle: nil), forCellReuseIdentifier: cellIdentifier.PeopleCell)
        
        self.tableView.registerNib(UINib(nibName: cellIdentifier.BillCell, bundle: nil), forCellReuseIdentifier: cellIdentifier.BillCell)
    
        // Set CollectionView delegate and datasource 
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Hide CollectionView when the view display
        collectionView.hidden = true
    }

    // MARK :  CoreData Convenience
    
    var sharedContext : NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext!
    }

    // MARK :  Data Fetch
    
    func fetchAllLawmakers()->[Lawmaker]
    {
        let fetchRequest = NSFetchRequest(entityName : "Lawmaker")
        let sectionSortDescriptor = NSSortDescriptor(key:"name", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Lawmaker]
            
        } catch let error as NSError {
            print("\(error.description)")
            return [Lawmaker]()
        }
    }
    
    // MARK : Action Method
    
    @IBAction func segmentedControlChanged(sender: AnyObject) {
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            tableView.hidden = false
            tableView.reloadData()
            break
        case 1:
            tableView.hidden = false
            
            let spinActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
            spinActivity.labelText = "Loading..."
            
            TPPClient.sharedInstance().getBills() { (bills, error) in
                
                if let bills = bills {

                    self.bills = bills
                    
                    dispatch_async(dispatch_get_main_queue())  {
                        self.tableView.reloadData()
                        spinActivity.hide(true)
                    }

                } else {
                    print(error)
                }
            }
            break
        case 2:
            collectionView.hidden = false
            tableView.hidden = true
            
            let spinActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
            spinActivity.labelText = "Loading..."
            
            TPPClient.sharedInstance().getParties() { (parties, error) in
            
                if let parties = parties {
                    print(parties)
                    self.parties = parties
                    
                    dispatch_async(dispatch_get_main_queue())  {
                        self.collectionView.reloadData()
                        spinActivity.hide(true)
                    }
                }
                else {
                    print(error)
                }
            }
            
            break
        default:
            break
        }
    }
    
    // MARK : Helper
    
    func buildTableViewIndex() {
        
        // Create lawmakerInfo array
        lawmakerInfo = lawmakers.map({ (customArray:Lawmaker)->LawmakerInfo in
            
            return LawmakerInfo(name: customArray.name!, party: customArray.party!, imageUrl: customArray.imageUrl!)
        })
    
        indexInfo = buildIndex(lawmakerInfo)
        
     }
    
    func buildIndex(lawmakers: [LawmakerInfo]) -> [Entry] {
        
        // Get the first korean character 
        // let letters = lawmakers.map {  (lawmaker) -> Character in
        //    lawmaker.name.hangul[0]
        // }
        
        // Create the array that contains the first letter of lawmaker's name
        let letters = lawmakers.map {  (lawmaker) -> Character in
            Character(lawmaker.name.substringToIndex(lawmaker.name.startIndex.advancedBy(1)).uppercaseString)
        }

        // Delete if there is a duplicate
        let distictLetters = distinct(letters)
        
        // Create the Entry type Array. Entry type represents (Character, [LawmakerInfo]) tuple
        return distictLetters.map {   (letter) -> Entry in
            
            return (letter, lawmakers.filter  {  (lawmaker) -> Bool in
            
                Character(lawmaker.name.substringToIndex(lawmaker.name.startIndex.advancedBy(1)).uppercaseString) == letter
            })
        }
        
        //return distictLetters.map {   (letter) -> Entry in

        //   return (letter, lawmakers.filter  {  (lawmaker) -> Bool in
        //                lawmaker.name.hangul[0] == letter
        //    })
        //}
        
    }

    func distinct<T:Equatable>(source: [T]) -> [T] {
        var unique = [T]()
        for item in source {
            if !unique.contains(item) {
                unique.append(item)
            }
        }
        return unique
    }
    
}

extension PoliticsViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK : UITableView DataSource Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0 :
            count = indexInfo[section].1.count
            break
        case 1 :
            count = bills.count
            break
        case 2 :
            break
        default:
            break
        }
        
        return count
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return segmentedControl.selectedSegmentIndex == 0 ? indexInfo.count : 1
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return segmentedControl.selectedSegmentIndex == 0 ? String(indexInfo[section].0): nil
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return segmentedControl.selectedSegmentIndex == 0 ? indexInfo.map({String($0.0)}):[String]()
    }

    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index 
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if segmentedControl.selectedSegmentIndex == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier.PeopleCell, forIndexPath: indexPath) as! LawmakerTableViewCell
            configureCell(cell, atIndexPath: indexPath)
            return cell
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier.BillCell, forIndexPath: indexPath) as! BillTableViewCell
            
            cell.nameLabel.text = bills[indexPath.row].name
            cell.sponsorLabel.text = bills[indexPath.row].sponsor
            cell.dateLabel.text = bills[indexPath.row].date
            cell.statusLabel.text = bills[indexPath.row].status
            
            return cell
        }
        
        return UITableViewCell()
    }

    // MARK : Congifure UITableviewCell
    
    func configureCell(cell:LawmakerTableViewCell , atIndexPath indexPath:NSIndexPath)
    {
        
        cell.nameLabel.text = indexInfo[indexPath.section].1[indexPath.row].name
        cell.partyLabel.text = indexInfo[indexPath.section].1[indexPath.row].party
        let urlString:String? = indexInfo[indexPath.section].1[indexPath.row].imageUrl
        let url = NSURL(string: urlString!)!
        
        /*
         Fetch a lawmaker by using a given imageUrl string to check whether an image is cached
           If an image is not cahced, httprequest function is invoked to download an image
        */
        let fetchRequest = NSFetchRequest(entityName : "Lawmaker")
        let predicate = NSPredicate(format: "imageUrl=%@", urlString!)
        fetchRequest.predicate = predicate
        // In order to fetch a single object
        fetchRequest.fetchLimit = 1
    
        var fetchedResults:[Lawmaker]!
        let searchedLawmaker:Lawmaker!
        
        do {
            fetchedResults =  try sharedContext.executeFetchRequest(fetchRequest) as! [Lawmaker]
        } catch let error as NSError {
            print("\(error.description)")
        }
        // Get a single fetched object
        searchedLawmaker = fetchedResults.first
        
        var pinnedImage:UIImage?
        cell.imageView!.image = nil
        
        if  searchedLawmaker.pinnedImage != nil {
            #if DEBUG
            log.debug("images exist")
            #endif
            pinnedImage = searchedLawmaker.pinnedImage
        }
        else {
        
            let task = TPPClient.sharedInstance().taskForGetImage(url) { data, error  in
            
                if let data = data {
                
                    let image = UIImage(data : data)
                
                    dispatch_async(dispatch_get_main_queue()) {
                        searchedLawmaker.pinnedImage = image
                        cell.profileImageView!.image = image
                    }
                }
            
            }
            //  The cells in the tableviews get reused when you scroll
            //  So when a completion handler completes, it will set the image on a cell,
            //  even if the cell is about to be reused, or is already being reused.
            //  The table view cells need to cancel their download task when they are reused.
            cell.taskToCancelifCellIsReused = task
        }
       
        cell.profileImageView!.image = pinnedImage

    }
    
    // MARK : UITableView Delegate Method
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("showLawmaker") as! LawmakerDetailViewController
        
        navigationController?.pushViewController(controller, animated: true)
    }

}

// MARK: - PoliticsViewController: UICollectionDelegate, UICollectionViewDataSource

extension PoliticsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
  
    // MARK : UICollectionViewDataSource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(parties.count)
        return parties.count 
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier.PartyCell, forIndexPath: indexPath) as! PartyCollectionViewCell
        
        //configureCollectionCell(cell, atIndexPath: indexPath)
        cell.logoImageView.image = parties[indexPath.row].thumbnail
        
        return cell
    }
    
}

// Copyright © 2016년 minsone : http://minsone.github.io/mac/ios/linear-hangul-in-objective-c-swift

extension String {
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    var hangul: String {
        get {
            let hangle = [
                ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"],
                ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"],
                ["","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
            ]
            
            return characters.reduce("") { result, char in
                if case let code = Int(String(char).unicodeScalars.reduce(0){$0.0 + $0.1.value}) - 44032
                    where code > -1 && code < 11172 {
                        let cho = code / 21 / 28, jung = code % (21 * 28) / 28, jong = code % 28;
                        return result + hangle[0][cho] + hangle[1][jung] + hangle[2][jong]
                }
                return result + String(char)
            }
        }
    }
}