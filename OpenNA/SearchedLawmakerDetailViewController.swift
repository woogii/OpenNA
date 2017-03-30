//
//  SearchedLawmakerDetailViewController.swift
//  OpenNA
//
//  Created by Hyun on 2016. 6. 26..
//  Copyright © 2016년 wook2. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// MARK : - Enum (For Cell IndexPath Row)

enum CustomCell:Int {
  case birth = 0, address, blog, education, homepage
}


// MARK : - SearchedLawmakerDetailViewController: UIViewController

class SearchedLawmakerDetailViewController: UIViewController {
  
  // MARK : - Property
  
  @IBOutlet weak var profileImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var favoriteButton: UIButton!
  
  var image:String?
  var name : String?
  var birth:String?
  var address: String?
  var party:String?
  var when_elected:String?
  var blog : String?
  var education : String?
  var homepage:String?
  var district:String?
  var sharedContext : NSManagedObjectContext {
    return CoreDataStackManager.sharedInstance().managedObjectContext!
  }

  // MARK : - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    makeCircleProfileImageView()
  }
  
  func makeCircleProfileImageView() {
    profileImage.layer.cornerRadius = profileImage.frame.size.width/2
    profileImage.clipsToBounds = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    super.viewWillAppear(animated)
  
    if let imageString = image {
      
      let url = URL(string: imageString)
      
      _ = RestClient.sharedInstance().taskForGetImage(url!) { data, error  in
        
        if let data = data {
          
          let image = UIImage(data : data)
          
          DispatchQueue.main.async {
            
            self.profileImage!.image = image
          }
        } else {
          CommonHelper.showAlertWithMsg(self, msg: (error?.localizedDescription)!, showCancelButton: false,
                                        okButtonTitle: Constants.Alert.Title.OK, okButtonCallback: nil)
        }
      }
    } else {
      profileImage.image = UIImage(named: Constants.Strings.SearchVC.defaultImageName)
    }
    
    // profileImage.image = pinnedImage
    nameLabel.text = name!
    
    let fetchedResults = fetchLawmakerInList()
    fetchedResults!.count == 0 ? (favoriteButton.setImage(UIImage(named:Constants.Images.FavoriteIconEmpty), for: .normal)) : (favoriteButton.setImage(UIImage(named:Constants.Images.FavoriteIconFilled), for: .normal))
    
  }
  
  // MARK : - Prepare For Segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == Constants.Identifier.segueToWebViewVC {
      let controller = segue.destination as! WebViewController
      controller.urlString = homepage
    }
  }
  
  @IBAction func pushBackButton(_ sender: UIBarButtonItem) {
    _ = navigationController?.popViewController(animated: true)
  }
  
  @IBAction func favoriteButtonTapped(_ sender: UIButton) {
    
    let fetchedResults = fetchLawmakerInList()
    
    // If there is not a lawmaker in Favorite List, add it to the list
    if fetchedResults!.count == 0  {
  
      let _ = LawmakerInList(name: name, image: image, party: party, birth: birth, homepage: homepage, when_elected: when_elected, district: district, context: sharedContext)
      
      do {
        try sharedContext.save()
      } catch {
        #if DEBUG
          print("\(error)")
        #endif
      }
      
      favoriteButton.setImage(UIImage(named:Constants.Images.FavoriteIconFilled), for: .normal)
    } else {
      
      // If the lawmaker is already in Favorite List, delete it from the list
      
      guard let result = fetchedResults!.first else {
        return
      }
      
      sharedContext.delete(result)
      
      do {
        try sharedContext.save()
      } catch {
        #if DEBUG
          print("\(error)")
        #endif
      }
      
      favoriteButton.setImage(UIImage(named:Constants.Images.FavoriteIconEmpty),  for: .normal)
    }

  }
  
  // MARK : - Fetch Lawmakers in Favorite List
  
  func fetchLawmakerInList()->[LawmakerInList]? {
    
    // Fetch a single lawmaker with given name and image
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : Constants.Entity.LawmakerInList)
    let firstPredicate = NSPredicate(format: Constants.Fetch.PredicateForName, name!)
    let secondPredicate = NSPredicate(format: Constants.Fetch.PredicateForImage, image!)
    let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates:[firstPredicate,secondPredicate])
    fetchRequest.predicate = compoundPredicate
    
    // In order to fetch a single object
    fetchRequest.fetchLimit = 1
    
    
    var fetchedResults : [LawmakerInList]?
    
    do {
      fetchedResults = try sharedContext.fetch(fetchRequest) as? [LawmakerInList]
    } catch let error as NSError {
      #if DEBUG
        print("\(error.description)")
      #endif
    }
    
    #if DEBUG
      print("fetch result : \(fetchedResults)")
    #endif
    
    return fetchedResults
  }

}

// MARK: - SearchedLawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource

extension SearchedLawmakerDetailViewController : UITableViewDelegate, UITableViewDataSource {
  
  // MARK : - UITableViewDataSource Methods
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Constants.Strings.LawmakerDetailVC.NumOfProfileCells
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch(indexPath.row) {
      
    case CustomCell.birth.rawValue:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.BirthLabelKr
        cell.descriptionLabel.text = birth
        return cell
      }
    case CustomCell.address.rawValue:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.AddressLabelKr
        cell.descriptionLabel.text = address
        return cell
      }
    case CustomCell.blog.rawValue:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.BlogLabelKr
        cell.descriptionLabel.text = blog
        return cell
      }
    case CustomCell.education.rawValue:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.EducationLabelKr
        cell.descriptionLabel.text = education
        return cell
      }
    default:
      if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.SearchedLawmakerDetailCell, for: indexPath) as? SearchedLawmakerDetailTableViewCell {
        cell.titleLabel.text = Constants.CustomCell.HomepageLabelKr
        cell.descriptionLabel.text = homepage
        return cell
      }
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return Constants.Strings.LawmakerDetailVC.HeaderTitle
  }
  
}
