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
import AlamofireImage
import Alamofire

// MARK: - PoliticsViewController : UIViewController

class PoliticsViewController: UIViewController  {
  
  // MARK : - Property
  
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
  
  // MARK : - CoreData Convenience
  
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }
  
  // MARK : - View Life Cycle
  
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    configureLayout()
    lawmakers = fetchAllLawmakers()
    buildTableViewIndex()
    
  }

  // MARK : - Configure Layout
  
  func configureLayout() {
    
    // Register Nib Objects
    self.tableView.register(UINib(nibName: Constants.Identifier.LawmakerCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.LawmakerCell)
    self.tableView.register(UINib(nibName: Constants.Identifier.BillCell, bundle: nil), forCellReuseIdentifier: Constants.Identifier.BillCell)
    
    // Set CollectionView delegate and datasource
    collectionView.dataSource = self
    collectionView.delegate = self
    
    // Hide CollectionView when the view display
    collectionView.isHidden = true
  }
  
  // MARK : - Data Fetch
  
  func fetchAllLawmakers()->[Lawmaker]
  {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.Lawmaker)
    let sectionSortDescriptor = NSSortDescriptor(key:Constants.Fetch.SortKeyForLawmaker, ascending: true)
    let sortDescriptors = [sectionSortDescriptor]
    fetchRequest.sortDescriptors = sortDescriptors
    
    do {
      return try sharedContext.fetch(fetchRequest) as! [Lawmaker]
      
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
      return [Lawmaker]()
    }
  }
  
  override func viewDidLayoutSubviews() {
    
    super.viewDidLayoutSubviews()
    configureCollectionViewFlowlayout()
  }
  
  func configureCollectionViewFlowlayout() {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collectionView.collectionViewLayout = layout
  }

  // MARK : - Action Method
  
  @IBAction func segmentedControlChanged(_ sender: AnyObject) {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case 0:
      tableView.setContentOffset(CGPoint.zero, animated: true)
      tableView.isHidden = false
      tableView.reloadData()
      break
    case 1:
      
      tableView.reloadData()
      tableView.setContentOffset(CGPoint.zero, animated: true)
      tableView.isHidden = false
      
      lastRowIndex = 20
      PoliticsViewController.page = 1
      
      let spinActivity = MBProgressHUD.showAdded(to: view, animated: true)
      spinActivity.label.text = Constants.ActivityIndicatorText.Loading
      
      TPPClient.sharedInstance().getBills(PoliticsViewController.page) { (bills, error) in
        
        if let bills = bills {
          
          self.bills = bills
          
          DispatchQueue.main.async  {
            self.tableView.reloadData()
            spinActivity.hide(animated:true)
          }
          
        } else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
          spinActivity.hide(animated:true)
          
        }
      }
      break
    case 2:
      
      collectionView.isHidden = false
      tableView.isHidden = true
      
      let spinActivity = MBProgressHUD.showAdded(to: view, animated: true)
      spinActivity.label.text = Constants.ActivityIndicatorText.Loading
      
      TPPClient.sharedInstance().getParties() { (parties, error) in
        
        if let parties = parties {
          
          self.parties = parties
        
          DispatchQueue.main.async  {
            self.collectionView.reloadData()
            spinActivity.hide(animated:true)
          }
        }
        else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
          spinActivity.hide(animated:true)
        }
      }
      
      break
    default:
      break
    }
  }
  
  // MARK : - Helper Methods
  
  func buildTableViewIndex() {
    
    indexInfo = buildIndex(lawmakers)
  }
  
  func buildIndex(_ lawmakers: [Lawmaker]) -> [Entry] {
    
    #if DEBUG
      // Get the first korean character
      // let letters = lawmakers.map {  (lawmaker) -> Character in
      //    lawmaker.name.hangul[0]
      // }
    #endif
    
    // Create the array that contains the first letter of lawmaker's name
    let letters = lawmakers.map {  (lawmaker) -> Character in
      Character(lawmaker.name!.substring(to:lawmaker.name!.characters.index(lawmaker.name!.startIndex, offsetBy: 1)).uppercased())
    }
    
    // Delete if there is a duplicate
    let distictLetters = distinct(letters)
    
    // Create the Entry type Array. Entry type represents (Character, [Lawmaker]) tuple
    return distictLetters.map {   (letter) -> Entry in
      
      return (letter, lawmakers.filter  {  (lawmaker) -> Bool in
        
        Character(lawmaker.name!.substring(to:lawmaker.name!.characters.index(lawmaker.name!.startIndex, offsetBy: 1)).uppercased()) == letter
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
  
  func distinct<T:Equatable>(_ source: [T]) -> [T] {
    
    var unique = [T]()
    
    for item in source {
      
      if !unique.contains(item) {
        unique.append(item)
      }
      
    }
    return unique
  }
  
}

// MARK : - PoliticsViewController : UITableViewDelegate, UITableViewDataSource

extension PoliticsViewController : UITableViewDelegate, UITableViewDataSource {
  
  
  // MARK : - UITableView DataSource Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
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
    
    if segmentedControl.selectedSegmentIndex == 0 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.LawmakerCell, for: indexPath) as! LawmakerTableViewCell
      configureCell(cell, atIndexPath: indexPath)
      return cell
    }
    else if segmentedControl.selectedSegmentIndex == 1 {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.BillCell, for: indexPath) as! BillTableViewCell
      
      cell.nameLabel.text = bills[indexPath.row].name
      cell.sponsorLabel.text = bills[indexPath.row].sponsor
      cell.statusLabel.text = bills[indexPath.row].status
      
      return cell
    }
    
    return UITableViewCell()
  }
  
  // MARK : - Congifure UITableviewCell
  
  func configureCell(_ cell:LawmakerTableViewCell , atIndexPath indexPath:IndexPath)
  {
    
    cell.nameLabel.text = indexInfo[indexPath.section].1[indexPath.row].name
    cell.partyLabel.text = indexInfo[indexPath.section].1[indexPath.row].party
    let urlString:String? = indexInfo[indexPath.section].1[indexPath.row].image
    let url = URL(string: urlString!)!
    
    /*
     Fetch a lawmaker by using a given imageUrl string to check whether an image is cached
     If an image is not cahced, http request function is invoked to download an image
     */
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.Lawmaker )
    let predicate = NSPredicate(format: Constants.Fetch.PredicateForImage, urlString!)
    fetchRequest.predicate = predicate
    // In order to fetch a single object
    fetchRequest.fetchLimit = 1
    
    var fetchedResults:[Lawmaker]!
    let searchedLawmaker:Lawmaker!
    
    do {
      fetchedResults =  try sharedContext.fetch(fetchRequest) as! [Lawmaker]
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
    }
    // Get a single fetched object
    searchedLawmaker = fetchedResults.first
    
    var pinnedImage:UIImage?
    cell.imageView!.image = nil
    
    if  searchedLawmaker.pinnedImage != nil {
      #if DEBUG
        print("images exist")
      #endif
      pinnedImage = searchedLawmaker.pinnedImage
    }
    else {
      
      let task = TPPClient.sharedInstance().taskForGetImage(url) { data, error  in
        
        if let data = data {
          
          let image = UIImage(data : data)
          
          DispatchQueue.main.async {
            searchedLawmaker.pinnedImage = image
            cell.profileImageView!.image = image
          }
        }
        
      }
      
      /*  The cells in the tableviews get reused when you scroll. So when a completion handler completes, it will set the image on a cell, even if the cell is about to be reused, or is already being reused.
          The table view cells need to cancel their download task when they are reused. */
      cell.taskToCancelifCellIsReused = task
    }
    
    cell.profileImageView!.image = pinnedImage
    
  }
  
  // MARK : - UITableView Delegate Methods
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 140
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case 0 :
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.LawmakerDetailVC) as! LawmakerDetailViewController
      
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
      let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.BillDetailVC) as! BillDetailViewController
      
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
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case 1:
      #if DEBUG
        print("loadingData : \(self.loadingData)")
        print("lastRowIndex: \(self.lastRowIndex)")
      #endif
      
      if !loadingData && indexPath.row == lastRowIndex - 1{
        #if DEBUG
          print("indexPath = \(indexPath.row)")
        #endif
        loadingData = true
        let spinActivity = MBProgressHUD.showAdded(to: view, animated: true)
        spinActivity.label.text = Constants.ActivityIndicatorText.Loading
        PoliticsViewController.page += 1
        
        TPPClient.sharedInstance().getBills(PoliticsViewController.page) { (bills, error) in
          
          if let addedbills = bills {
            
            #if DEBUG
              print("appended bills count : \(addedbills.count)")
            #endif
            
            if addedbills.count == 0 {
              
              DispatchQueue.main.async  {
                spinActivity.hide(animated:true)
              }
              return
            }
            
            self.bills.append(contentsOf: addedbills)
            self.lastRowIndex += 20
            self.loadingData = false
            
            DispatchQueue.main.async  {
              self.tableView.reloadData()
              spinActivity.hide(animated:true)
            }
          }
          else {
            
            CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                          okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
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
  
  // MARK : - UICollectionViewDataSource Methods
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return parties.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var logoImageRequest : Request?
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.PartyImageCell, for: indexPath) as! PartyCollectionViewCell
    cell.logoImageView!.image = nil
    logoImageRequest?.cancel()
    
    let urlString =  Constants.Strings.Party.partyImageUrl + String(parties[indexPath.row].id) + Constants.Strings.Party.partyImageExtension
    
    logoImageRequest = TPPClient.sharedInstance().taskForGetDirectImage(urlString) { image, error  in
      
      
      if let image = image {
        DispatchQueue.main.async {
          self.parties[indexPath.row].thumbnail = image
          cell.logoImageView?.image = image
        }
      } else {
        
        DispatchQueue.main.async {
          let defaultImage = UIImage(named:Constants.Strings.PoliticsVC.PartyPlaceholder)
          self.parties[indexPath.row].thumbnail = self.textToImage(self.parties[indexPath.row].name as NSString, inImage: defaultImage!, atPoint: CGPoint(x: 20,y: 50), cellSize: cell.frame.size)
          cell.logoImageView.image = self.parties[indexPath.row].thumbnail
        }
        
      }
      
    }

    
    return cell
  }

  // MARK : - Draw the text into an Image
  
  func textToImage(_ drawText: NSString, inImage: UIImage, atPoint:CGPoint, cellSize:CGSize)->UIImage{
    
    // Setup the font specific variables
    let textColor: UIColor = UIColor.black
    let textFont: UIFont = UIFont(name: Constants.Strings.Party.imageTextFont, size: 17)!
    
    //Setup the image context using the passed image.
    //UIGraphicsBeginImageContext(inImage.size)
    UIGraphicsBeginImageContext(cellSize)
    
    //Setups up the font attributes that will be later used to dictate how the text should be drawn
    let textFontAttributes = [
      NSFontAttributeName: textFont,
      NSForegroundColorAttributeName: textColor,
      ]
    
    //Put the image into a rectangle as large as the original image.
    inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
    print("image size : \(inImage.size)")
    print("cell size : \(cellSize)")
    // Creating a point within the space that is as bit as the image.
    //let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: inImage.size.width-10, height: inImage.size.height)
    
    let rect: CGRect = CGRect(x: atPoint.x, y: atPoint.y, width: cellSize.width-30, height: cellSize.height)
    
    //Now Draw the text into an image.
    drawText.draw(in: rect, withAttributes: textFontAttributes)
    
    // Create a new image out of the images we have created
    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    
    // End the context now that we have the image we need
    UIGraphicsEndImageContext()
    
    //And pass it back up to the caller.
    return newImage
    
  }
  
  // MARK : - UICollectionViewDelegate Methods
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let controller = storyboard?.instantiateViewController(withIdentifier: Constants.Identifier.WebViewVC) as! WebViewController
    
    controller.urlString = Constants.Strings.SearchVC.WikiUrl + parties[indexPath.row].name
    controller.hidesBottomBarWhenPushed = true
    
    navigationController?.pushViewController(controller, animated: true)
    
  }
}

extension PoliticsViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    let width = floor(self.collectionView.frame.size.width/3)
    return CGSize(width: width, height: width - 15)
  }
}

// Copyright © 2016년 minsone : http://minsone.github.io/mac/ios/linear-hangul-in-objective-c-swift

extension String {
  subscript (i: Int) -> Character {
    return self[self.characters.index(self.startIndex, offsetBy: i)]
  }
  
  var hangul: String {
    get {
      let hangle = [
        ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"],
        ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"],
        ["","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
      ]
      
      return characters.reduce("") { result, char in
        if case let code = Int(String(char).unicodeScalars.reduce(0){$0.0 + $0.1.value}) - 44032, code > -1 && code < 11172 {
          let cho = code / 21 / 28, jung = code % (21 * 28) / 28, jong = code % 28;
          return result + hangle[0][cho] + hangle[1][jung] + hangle[2][jong]
        }
        return result + String(char)
      }
    }
  }
}
