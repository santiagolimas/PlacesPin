//
//  PlaceTableViewController.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 9/25/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class PlaceTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,
                                UISearchResultsUpdating {


    var places: [PlaceMO] = []
    var fetchResultController: NSFetchedResultsController<PlaceMO>!
    
    var searchController: UISearchController!
    var searchResults: [PlaceMO] = []
    
    
    @IBOutlet var emptyPlaceView: UIView!


    // MARK: - View controller life cycle


   override func viewDidLoad() {
          super.viewDidLoad()

    //Prepare the empty view
    tableView.backgroundView = emptyPlaceView
    tableView.backgroundView?.isHidden = true

    tableView.cellLayoutMarginsFollowReadableWidth = true
    
//    navigationController?.navigationBar.prefersLargeTitles = true
    
    configureNavigator()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    

    if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
                     navigationController?.navigationBar.largeTitleTextAttributes =
                     [
                        NSAttributedString.Key.foregroundColor: UIColor.black,
                         NSAttributedString.Key.font: customFont
                     ]
    }

    navigationController?.hidesBarsOnSwipe = true
    navigationController?.navigationBar.isHidden = false
//    navigationController?.navigationBar.standardAppearance


        // Fetch data from data store
        let fetchRequest: NSFetchRequest<PlaceMO> = PlaceMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self

            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    places = fetchedObjects
                }
            } catch {
                print(error)
            }
        }

        searchController = UISearchController(searchResultsController: nil)
    
//        self.navigationItem.searchController = searchController

        tableView.tableHeaderView = searchController.searchBar

        searchController.searchResultsUpdater = self
    
        searchController.obscuresBackgroundDuringPresentation = false

        searchController.searchBar.placeholder = "Search places..."
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor =  UIColor(red: 68, green: 108, blue: 179)

    

        prepareNotification()
        tableView.tableFooterView = UIView()
//        self.tableView.isScrollEnabled = tableView.contentSize.height > tableView.frame.height;


      }


    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.tableView.isScrollEnabled = tableView.contentSize.height > tableView.frame.height

        configureNavigator()
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.isHidden = false
        
        

    }


    private func configureNavigator() {
              guard let navigationController = navigationController else { return }
              navigationController.navigationBar.prefersLargeTitles = true
              navigationItem.largeTitleDisplayMode = .automatic
              navigationController.navigationBar.sizeToFit()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections


        if places.count > 0 {
                tableView.backgroundView?.isHidden = true
                tableView.separatorStyle = .singleLine

        } else {
                tableView.backgroundView?.isHidden = false
                tableView.separatorStyle = .none
        }


        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        if searchController.isActive{
            return searchResults.count
        }else{
            return places.count
        }

    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlaceTableViewCell
        let place = (searchController.isActive) ? searchResults[indexPath.row] : places[indexPath.row]


        cell.nameLabel.text = place.name

        if let placeImage = place.image {
            cell.thumbnailImageView.image = UIImage(data: placeImage as Data)
        }

        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type



        cell.checkImageVIew.isHidden = places[indexPath.row].isVisited ? false : true


        return cell
    }

    
    
    // MARK: - Table view delegate

   override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {


    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
        // Delete the row from the data store
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            let restaurantToDelete = self.fetchResultController.object(at: indexPath)
            context.delete(restaurantToDelete)

            appDelegate.saveContext()
        }

        // Call completion handler with true to indicate
        completionHandler(true)
    }


        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in

            let defaultText = "Just checking in at " + self.places[indexPath.row].name!

            let activityController: UIActivityViewController


            if let placeImage = self.places[indexPath.row].image,
                            let imageToShare = UIImage(data: placeImage as Data)
            {
                        activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else  {
                        activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }

            //For Ipad
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }


            self.present(activityController, animated: true, completion: nil)


            completionHandler(true)
        }


        deleteAction.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAction.image = UIImage(named: "delete")

        shareAction.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(named: "share")

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])

            return swipeConfiguration
        }


    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {


        let checkAction = UIContextualAction(style: .normal, title: "CheckIn") { (action, sourceView, completionHandler) in


            let cell = tableView.cellForRow(at: indexPath) as! PlaceTableViewCell
            self.places[indexPath.row].isVisited = (self.places[indexPath.row].isVisited) ? false : true
            
            cell.checkImageVIew.isHidden = self.places[indexPath.row].isVisited ? false : true

            completionHandler(true)
        }


        let checkIcon = places[indexPath.row].isVisited ? "undo" : "tick"

        checkAction.backgroundColor = UIColor(red: 3, green: 166, blue: 120)

        checkAction.image = UIImage(named: checkIcon)

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [checkAction])


        return swipeConfiguration
    }



    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {


        switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    tableView.insertRows(at: [newIndexPath], with: .fade)
                }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            case .update:
                if let indexPath = indexPath {
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            default:
                tableView.reloadData()
            }

            if let fetchedObjects = controller.fetchedObjects {
                places = fetchedObjects as! [PlaceMO]
            }
        }


        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }


    // MARK: - Functions for the navigation bar
    func filterContent(for searchText: String) {
        searchResults = places.filter({ (place) -> Bool in
            if let name = place.name,
                let location = place.location {

                    let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                
                return isMatch
            }

            return false
        })
    }


    func updateSearchResults(for searchController: UISearchController) {

        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }


    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        if searchController.isActive {
            return false
        } else {
            return true
        }
    }



    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showPlaceDetail" {
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! PlaceDetailViewController
                destinationController.place = (searchController.isActive) ? searchResults[indexPath.row] :
                    places[indexPath.row]
                destinationController.hidesBottomBarWhenPushed = true

            }
        }
        
        
    }

    // MARK: - Unwind Scenes
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Method for notifications
    func prepareNotification() {
        
        if places.count <= 0 {
            return
        }

        let randomNum = Int.random(in: 0..<places.count)
        let suggestedPlace = places[randomNum]

        let content = UNMutableNotificationContent()
        content.title = "Place Recommendation"
        content.subtitle = "Don't forget to visit this place"
        content.body = "I recommend you to check out \(suggestedPlace.name!). This place is one of your favorites. It is located at \(suggestedPlace.location!)."
        content.sound = UNNotificationSound.default

        
        let tempDirURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempFileURL = tempDirURL.appendingPathComponent("suggested-place.jpg")

        if let image = UIImage(data: suggestedPlace.image! as Data) {

            try? image.jpegData(compressionQuality: 1.0)?.write(to: tempFileURL)
            
            if let placeImage = try? UNNotificationAttachment(identifier: "placeImage", url: tempFileURL, options: nil) {
                content.attachments = [placeImage]
            }
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        let request = UNNotificationRequest(identifier: "foodpin.restaurantSuggestion", content: content, trigger: trigger)

        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    }





    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

