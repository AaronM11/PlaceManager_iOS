//
//  AddPlaceTableViewController.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/21/18.
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//

import UIKit

class AddPlaceTableViewController: UITableViewController {

    var place: Place?
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var addressTitleTextField: UITextField!
    @IBOutlet weak var addressStreetTextField: UITextField!
    @IBOutlet weak var elevationTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: - Constants
    let saveUnwind = "saveUnwind"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupTextField(place: place)
        updateSaveButtonState()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    private func setupTextField(place: Place?) {
        guard let place = place else { return }
        nameTextField.text = place.name
        addressTitleTextField.text = place.addressTitle
        addressStreetTextField.text = place.addressStreet
        descriptionTextField.text = place.description
        categoryTextField.text = place.category
        elevationTextField.text = String(place.elevation)
        latitudeTextField.text = String(place.latitude)
        longitudeTextField.text = String(place.longitude)
    }
    
    func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        let addressTitle = addressTitleTextField.text ?? ""
        let addressStreet = addressStreetTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        let elevation = elevationTextField.text ?? ""
        let latitude = latitudeTextField.text ?? ""
        let longitude = longitudeTextField.text ?? ""
        saveButton.isEnabled = !name.isEmpty && !addressTitle.isEmpty && !addressStreet.isEmpty && !description.isEmpty && !category.isEmpty && !elevation.isEmpty && !latitude.isEmpty && !longitude.isEmpty
    
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == saveUnwind else { return }
        
        let name = nameTextField.text ?? ""
        let addressTitle = addressTitleTextField.text ?? ""
        let addressStreet = addressStreetTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let category = categoryTextField.text ?? ""
        guard let elevationString = elevationTextField.text,
            let latitudeString = latitudeTextField.text ,
            let longitudeString = longitudeTextField.text else { return }
        
        let elevation = Double(elevationString) ?? 0.0
        let latitude = Double(latitudeString) ?? 0.0
        let longitude = Double(longitudeString) ?? 0.0
        
        place = Place(name: name, description: description, category: category, addressTitle: addressTitle, addressStreet: addressStreet, elevation: elevation, latitude: latitude, longitude: longitude)
        
    }
        
    
//    @IBAction func saveNewPlace(_ sender: UIBarButtonItem) {
//    }
//
//    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    let editPlace = "EditPlace"
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == editPlace {
////            let indexPath = tableView
////        }
//    }
 

}
