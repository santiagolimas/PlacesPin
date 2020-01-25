//
//  NewPlaceController.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 10/10/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import UIKit
import CoreData

class NewPlaceController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate,
                            UINavigationControllerDelegate{

    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var nameTextField: RoundedTextField! {
      didSet {
        nameTextField.tag = 1
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
      }
    }
    

    @IBOutlet var typeTextField: RoundedTextField! {
      didSet {
        typeTextField.tag = 2
        typeTextField.delegate = self
      }
    }

    @IBOutlet var addressTextField: RoundedTextField! {
      didSet {
        addressTextField.tag = 3
        addressTextField.delegate = self
      }
    }

    @IBOutlet var phoneTextField: RoundedTextField! {
        didSet {
          phoneTextField.tag = 4
          phoneTextField.delegate = self
        }
    }

    @IBOutlet var descriptionTextView: UITextView! {
        didSet {
          descriptionTextView.tag = 5
          descriptionTextView.layer.cornerRadius = 5.0
          descriptionTextView.layer.masksToBounds = true
        }
    }
    
    var place: PlaceMO!

        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        // Configure navigation bar appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        
        if let customFont = UIFont(name: "Rubik-Medium", size: 35.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: customFont ]
        }
        
        // Configure the table view's style
        tableView.separatorStyle = .none
        configureNavigator()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigator()
    }
    
    
    

    private func configureNavigator() {
          guard let navigationController = navigationController else { return }
          navigationController.navigationBar.prefersLargeTitles = true
          navigationItem.largeTitleDisplayMode = .automatic
          navigationController.navigationBar.sizeToFit()
      }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }

        return true
    }

   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {

            let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source", preferredStyle: .actionSheet)
            

            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera

                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default, handler: { (action) in
                
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary

                    self.present(imagePicker, animated: true, completion: nil)
                }
            })

            photoSourceRequestController.addAction(cameraAction)
            photoSourceRequestController.addAction(photoLibraryAction)

            // For iPad
            if let popoverController = photoSourceRequestController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                        popoverController.sourceView = cell
                        popoverController.sourceRect = cell.bounds
                }
            }

            present(photoSourceRequestController, animated: true, completion: nil)

        }
    }

          
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedImage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        let leadingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .leading, relatedBy: .equal, toItem: photoImageView.superview, attribute: .leading, multiplier: 1, constant: 0)
            leadingConstraint.isActive = true

        let trailingConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .trailing, relatedBy: .equal, toItem: photoImageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
            trailingConstraint.isActive = true

        let topConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .top, relatedBy: .equal, toItem: photoImageView.superview, attribute: .top, multiplier: 1, constant: 0)
            topConstraint.isActive = true
        
        let bottomConstraint = NSLayoutConstraint(item: photoImageView as Any, attribute: .bottom, relatedBy: .equal, toItem: photoImageView.superview, attribute: .bottom, multiplier: 1, constant: 0)
            bottomConstraint.isActive = true


        dismiss(animated: true, completion: nil)
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

    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descriptionTextView.text == "" {
            
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
//        print("Name: \(nameTextField.text ?? "")")
//        print("Type: \(typeTextField.text ?? "")")
//        print("Location: \(addressTextField.text ?? "")")
//        print("Phone: \(phoneTextField.text ?? "")")
//        print("Description: \(descriptionTextView.text ?? "")")
//
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            
            place = PlaceMO(context: appDelegate.persistentContainer.viewContext)
            
            place.name = nameTextField.text
            place.type = typeTextField.text
            place.location = addressTextField.text
            place.phone = phoneTextField.text
            place.summary = descriptionTextView.text
            place.isVisited = false
            
            if let placeImage = photoImageView.image{
                place.image = placeImage.pngData()
            }
            
            print("Saving data to context...")
            appDelegate.saveContext()
        }
        
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
