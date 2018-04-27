//
//  AddPlaceTableViewController.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/10/18.
//  Email: amuseng1@asu.edu
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//  This software is provided to Arizona State University for the purpose
//  of grading and evaluation. This software is provided AS IS.
//

import UIKit

class AddPlaceTableViewController: UITableViewController {

    var place: PlaceWrapper?
    
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
        
        setupTextField(place: place)
        updateSaveButtonState()
    }

    // MARK: - Private
    private func setupTextField(place: PlaceWrapper?) {
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
        
        place = PlaceWrapper(name: name, description: description, category: category, addressTitle: addressTitle, addressStreet: addressStreet, elevation: elevation, latitude: latitude, longitude: longitude)
        
    }
}
