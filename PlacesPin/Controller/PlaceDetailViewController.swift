//
//  PlaceDetailViewController.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 10/8/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit

class PlaceDetailViewController: UIViewController, UITableViewDataSource,
UITableViewDelegate{

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: PlaceDetailHeaderView!
       
    var place: PlaceMO!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           navigationItem.largeTitleDisplayMode = .never
           
           // Configure header view
           headerView.nameLabel.text = place.name
           headerView.typeLabel.text = place.type
    //       headerView.headerImageView.image = UIImage(named: place.image)
        
            if let placeImage = place.image{
                headerView.headerImageView.image = UIImage(data: placeImage as Data)
            }
        
           headerView.checkImageView.isHidden = (place.isVisited) ? false : true
           
           // Set the table view's delegate and data source
           tableView.delegate = self
           tableView.dataSource = self
           
           // Configure the table view's style
           tableView.separatorStyle = .none
           
           navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           navigationController?.navigationBar.shadowImage = UIImage()
           navigationController?.navigationBar.tintColor = .white

           tableView.contentInsetAdjustmentBehavior = .never
        
           navigationController?.hidesBarsOnSwipe = false
       }
       
        
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)

          navigationController?.hidesBarsOnSwipe = false
          navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

     override var preferredStatusBarStyle: UIStatusBarStyle {
         return .lightContent
     }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {

        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceDetailIconTextCell.self), for: indexPath) as! PlaceDetailIconTextCell
            
            cell.iconImageView.image = UIImage(named: "phone")
                    cell.shortTextLabel.text = place.phone
                    cell.selectionStyle = .none

                    return cell
            
        case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceDetailIconTextCell.self), for: indexPath) as! PlaceDetailIconTextCell
                    cell.iconImageView.image = UIImage(named: "map")
                    cell.shortTextLabel.text = place.location
                    cell.selectionStyle = .none

                    return cell
            
        case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceDetailTextCell.self), for: indexPath) as! PlaceDetailTextCell
                    cell.descriptionLabel.text = place.summary
                    cell.selectionStyle = .none

                    return cell
        case 3:
            
                    let cell = tableView.dequeueReusableCell(withIdentifier:
                    String(describing: PlaceDetailSeparatorCell.self), for: indexPath) as! PlaceDetailSeparatorCell
                    cell.titleLabel.text = "HOW TO GET HERE"
                    cell.selectionStyle = .none

                    return cell

          
        case 4:
            //Map Cell
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceDetailMapCell.self), for: indexPath) as! PlaceDetailMapCell
              
//                 cell.configure(location: place.location)
              
                  if let placeLocation = place.location {
                    cell.configure(location: placeLocation)
                  }

                  return cell
            
            

        default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
            
            
                }
        }

         
        

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.place = place
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
