//
//  AboutTableViewController.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 05/11/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {

    
    var sectionTitles = ["Feedback", "Follow Us"]
    
    var sectionContent = [
        
        [(image: "store", text: "Rate us on App Store", link: "https://www.apple.com/itunes/charts/paid-apps/"),
         (image: "chat", text: "Tell us your feedback", link: "https://www.apple.com/itunes/charts/paid-apps/")],
                          
        [(image: "twitter", text: "Twitter", link: "https://twitter.com"),
         (image: "facebook", text: "Facebook", link: "https://facebook.com"),
        (image: "instagram", text: "Instagram", link: "https://www.instagram.com")]
    ]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationController?.navigationBar.isHidden = false
        tableView.cellLayoutMarginsFollowReadableWidth = true

        // Configure navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
            
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: customFont ]
        }

        tableView.tableFooterView = UIView()

        configureNavigator()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            

        configureNavigator()
//        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.isHidden = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
          

          if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes =
                [ NSAttributedString.Key.foregroundColor: UIColor.black,
                  NSAttributedString.Key.font: customFont
                ]
          }

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
        return sectionTitles.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sectionContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath)
        
        let cellData = sectionContent[indexPath.section][indexPath.row]
        cell.textLabel?.text = cellData.text
        cell.imageView?.image = UIImage(named: cellData.image)
        
    
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let link = sectionContent[indexPath.section][indexPath.row].link

        switch indexPath.section {
            

        //Feedback
        case 0:
//            if indexPath.row == 0 {
//                if let url = URL(string: link) {
//                    UIApplication.shared.open(url)
//                }
//            }else if indexPath.row == 1{
//                performSegue(withIdentifier: "showWebView", sender: self)
//            }
            
            if let url = URL(string: link){
                    let safariController = SFSafariViewController(url: url)
                    present(safariController, animated: true, completion: nil)
                
            }
                
        //Follow
        case 1:
            if let url = URL(string: link){
                let safariController = SFSafariViewController(url: url)
                present(safariController, animated: true, completion: nil)
            
        }
            
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    //Using WebView
//        if segue.identifier == "showWebView"{
//            
//            if let destinationController = segue.destination as? WebViewController,
//                let indexPath = tableView.indexPathForSelectedRow{
//                
//                destinationController.targetURL = sectionContent[indexPath.section][indexPath.row].link
//            }
//        }
        
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
