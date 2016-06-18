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
    
    var lawmakers = [Lawmaker]()
    var bills     = [Bill]()
    var parties   = [Party]()
    var indexInfo = [Entry]()
    var loadingData = false
    var lastRowIndex = 20
    static var page = 1
    
    typealias Entry = (Character, [Lawmaker])
    
    // MARK :  View LifeCycle
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
    
    // MARK : Configure Layout
    func configureLayout() {
        
        // Register Nib Objects
        self.tableView.registerNib(UINib(nibName: Constants.Identifier.LawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.LawmakerCell)
        self.tableView.registerNib(UINib(nibName: Constants.Identifier.BillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.BillCell)
    
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
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.Lawmaker)
        let sectionSortDescriptor = NSSortDescriptor(key:Constants.Fetch.SortKeyForLawmaker, ascending: true)
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
            tableView.setContentOffset(CGPointZero, animated: true)
            tableView.hidden = false
            tableView.reloadData()
            break
        case 1:
            tableView.reloadData()
            tableView.setContentOffset(CGPointZero, animated: true)
            tableView.hidden = false
            
            lastRowIndex = 20
            PoliticsViewController.page = 1
            
            let spinActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
            spinActivity.labelText = Constants.ActivityIndicatorText.Loading
            
            TPPClient.sharedInstance().getBills(PoliticsViewController.page) { (bills, error) in
                
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
            spinActivity.labelText = Constants.ActivityIndicatorText.Loading
            
            TPPClient.sharedInstance().getParties() { (parties, error) in
                
                if let parties = parties {

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
        
        indexInfo = buildIndex(lawmakers)
    }
    
    func buildIndex(lawmakers: [Lawmaker]) -> [Entry] {
        
        #if DEBUG
            // Get the first korean character
            // let letters = lawmakers.map {  (lawmaker) -> Character in
            //    lawmaker.name.hangul[0]
            // }
        #endif
        
        // Create the array that contains the first letter of lawmaker's name
        let letters = lawmakers.map {  (lawmaker) -> Character in
            Character(lawmaker.name!.substringToIndex(lawmaker.name!.startIndex.advancedBy(1)).uppercaseString)
        }
        
        // Delete if there is a duplicate
        let distictLetters = distinct(letters)
        
        // Create the Entry type Array. Entry type represents (Character, [Lawmaker]) tuple
        return distictLetters.map {   (letter) -> Entry in
            
            return (letter, lawmakers.filter  {  (lawmaker) -> Bool in
                
                Character(lawmaker.name!.substringToIndex(lawmaker.name!.startIndex.advancedBy(1)).uppercaseString) == letter
                })
        }
        
        #if DEBUG
            //return distictLetters.map {   (letter) -> Entry in
            
            //   return (letter, lawmakers.filter  {  (lawmaker) -> Bool in
            //                lawmaker.name.hangul[0] == letter
            //    })
            //}
        #endif
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
            log.debug("\(bills.count)")
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
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.LawmakerCell, forIndexPath: indexPath) as! LawmakerTableViewCell
            configureCell(cell, atIndexPath: indexPath)
            return cell
        }
        else if segmentedControl.selectedSegmentIndex == 1 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Identifier.BillCell, forIndexPath: indexPath) as! BillTableViewCell
            log.debug("\(indexPath.row)")
            cell.nameLabel.text = bills[indexPath.row].name
            cell.sponsorLabel.text = bills[indexPath.row].sponsor
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
        let urlString:String? = indexInfo[indexPath.section].1[indexPath.row].image
        let url = NSURL(string: urlString!)!
        
        /*
         Fetch a lawmaker by using a given imageUrl string to check whether an image is cached
         If an image is not cahced, httprequest function is invoked to download an image
         */
        let fetchRequest = NSFetchRequest(entityName : Constants.Entity.Lawmaker )
        let predicate = NSPredicate(format: Constants.Fetch.PredicateForImage, urlString!)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0 :
            let controller = storyboard?.instantiateViewControllerWithIdentifier(Constants.Identifier.LawmakerDetailVC) as! LawmakerDetailViewController
            
            controller.name  = indexInfo[indexPath.section].1[indexPath.row].name
            controller.birth = indexInfo[indexPath.section].1[indexPath.row].birth
            controller.party = indexInfo[indexPath.section].1[indexPath.row].party
            controller.when_elected = indexInfo[indexPath.section].1[indexPath.row].when_elected
            controller.district = indexInfo[indexPath.section].1[indexPath.row].district
            controller.homepage = indexInfo[indexPath.section].1[indexPath.row].homepage
            controller.image = indexInfo[indexPath.section].1[indexPath.row].image
            controller.pinnedImage = indexInfo[indexPath.section].1[indexPath.row].pinnedImage

            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
            
            break
        case 1 :
            let controller = storyboard?.instantiateViewControllerWithIdentifier(Constants.Identifier.BillDetailVC) as! BillDetailViewController
            
            // controller.bill = bills[indexPath.row]
            controller.name = bills[indexPath.row].name
            controller.proposedDate = bills[indexPath.row].proposeDate
            controller.status = bills[indexPath.row].status
            controller.sponsor = bills[indexPath.row].sponsor
            controller.documentUrl = bills[indexPath.row].documentUrl
            controller.summary = bills[indexPath.row].summary
            controller.assemblyID = bills[indexPath.row].assemblyId
        
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
            
            break
        case 2 :
            break
        default:
            break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    
        switch segmentedControl.selectedSegmentIndex {
            
        case 1:
            log.debug("loadingData : \(loadingData)")
            log.debug("lastRowIndex: \(lastRowIndex)")
            if !loadingData && indexPath.row == lastRowIndex - 1{
                
                log.debug("indexPath = \(indexPath.row)")
                loadingData = true
                let spinActivity = MBProgressHUD.showHUDAddedTo(view, animated: true)
                spinActivity.labelText = Constants.ActivityIndicatorText.Loading
                PoliticsViewController.page += 1
                
                TPPClient.sharedInstance().getBills(PoliticsViewController.page) { (bills, error) in
                
                    if let addedbills = bills {
                    
                        log.debug("appended bills count : \(addedbills.count)")
                        
                        if addedbills.count == 0 {
                        
                            dispatch_async(dispatch_get_main_queue())  {
                                spinActivity.hide(true)
                            }
                            return
                        }
                        
                        self.bills.appendContentsOf(addedbills)
                        self.lastRowIndex += 20
                        self.loadingData = false
                        
                        dispatch_async(dispatch_get_main_queue())  {
                            self.tableView.reloadData()
                            spinActivity.hide(true)
                        }
                    }
                    else {
                        print(error)
                    }
                }
            }
            break
        default:
            break
        }
    }
    
}

// MARK: - PoliticsViewController: UICollectionDelegate, UICollectionViewDataSource

extension PoliticsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK : UICollectionViewDataSource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return parties.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Identifier.PartyImageCell, forIndexPath: indexPath) as! PartyCollectionViewCell
        
        cell.logoImageView.image = parties[indexPath.row].thumbnail
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
                
        let controller = storyboard?.instantiateViewControllerWithIdentifier(Constants.Identifier.WebViewVC) as! WebViewController
        
        controller.urlString = Constants.WikiUrl + parties[indexPath.row].name
        controller.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(controller, animated: true)
        
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