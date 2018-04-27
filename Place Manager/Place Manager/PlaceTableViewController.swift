//
//  PlaceTableViewController.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/10/18.
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//

import UIKit
import CoreLocation

class PlaceTableViewController: UITableViewController {
    
    var places = [PlaceWrapper]()
    var selectedIndexPath: IndexPath?
    
    var selectedCells: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        initializeCoreData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeTableViewCell", for: indexPath)
        
        let place = places[indexPath.row]

        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = place.addressTitle

        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedCells.count == 2 && !selectedCells.contains(indexPath) {
            return nil
        }
        selectedCells.append(indexPath)
        if selectedCells.count == 2 {
            calculateSphericalDistance()
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = selectedCells.index(of: indexPath) {
            selectedCells.remove(at: index)
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let placeDB = PlaceDB()
            let placeToDelete = places[indexPath.row]
            placeDB.deletePlace(name: placeToDelete.name)
            placeDB.saveContext()
            
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Private
    private func calculateSphericalDistance() {
        let toPlace = places[0]
        let fromPlace = places[1]
        
        let toLocation = CLLocation(latitude: CLLocationDegrees(toPlace.latitude), longitude: CLLocationDegrees(toPlace.longitude))
        
        let fromLocation = CLLocation(latitude: CLLocationDegrees(fromPlace.latitude), longitude: fromPlace.longitude)
        
        let distance = toLocation.distance(from: fromLocation).magnitude
        let kilometers = String(format: "%.2f", distance/1000.0) + " kilometers"
        print(kilometers)
        
        let distanceModel = SphericalDistanceModel(toPlace: toPlace.addressTitle, fromPlace: fromPlace.addressTitle, distance: kilometers, heading: "")
        displaySphericalDistance(with: distanceModel)
    }
    
    private func displaySphericalDistance(with model: SphericalDistanceModel) {
        let storyboard = UIStoryboard(name: "SphericalDistance", bundle: nil)
        guard let sphericalDistanceViewController = storyboard.instantiateViewController(withIdentifier: "SphericalDistanceTableViewController") as? SphericalDistanceTableViewController else { return }
        
        sphericalDistanceViewController.model = model
        if let navigationController = navigationController {
            navigationController.pushViewController(sphericalDistanceViewController, animated: true)
        }
    }
    
    private func initializeCoreData() {
        let placeDB = PlaceDB()
        let placesFromDB = placeDB.getPlaces()
        
        if let placesFromDB = placesFromDB {
            for place in placesFromDB {
                let placeStruct = PlaceWrapper(name: place.name ?? "", description: place.detail ?? "" , category: place.category ?? "" , addressTitle: place.addressTitle ?? "" , addressStreet: place.addressStreet ?? "" , elevation: place.elevation , latitude: place.latitude, longitude: place.longitude)
                places.append(placeStruct)
            }
        }
        
        if places.count > 0 {
            return
        }
        
        if let path = Bundle.main.path(forResource: "places", ofType: "json") {
            do {
                let placeData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                createPlaceModels(with: placeData)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
    private func createPlaceModels(with placeData: Data) {
        let decoder = JSONDecoder()
        guard let jsonPlaces = try? decoder.decode([PlaceWrapper].self, from: placeData) else { return }
        places = jsonPlaces
        let placeDB = PlaceDB()
        
        for place in jsonPlaces {
            placeDB.addPlace(place: place)
        }
        
        placeDB.saveContext()
    }
    
    // MARK: - Navigation
    
    let editPlace = "editPlace"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == editPlace {
            guard let sender = sender as? UITableViewCell,
                  let indexPath = tableView.indexPath(for: sender),
                  let addPlaceTableViewController = segue.destination as? AddPlaceTableViewController else { return }
            selectedIndexPath = indexPath
            
            let place = places[indexPath.row]
            addPlaceTableViewController.place = place
        }
    }
    
    @IBAction func unwindToPlaceTableView(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
            let sourceViewController = segue.source as? AddPlaceTableViewController else { return }
        let placeDB = PlaceDB()
        if let place = sourceViewController.place {
            if let selectedIndexPath = selectedIndexPath {
                let placeToDelete = places[selectedIndexPath.row]
                placeDB.deletePlace(name: placeToDelete.name)
                places[selectedIndexPath.row] = place
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: places.count, section: 0)
                places.append(place)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            placeDB.addPlace(place: place)
            placeDB.saveContext()
        }
        selectedIndexPath = nil
    }
    
}
