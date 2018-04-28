//
//  PlaceTableViewController.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/10/18.
//  Email: amuseng1@asu.edu
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//  This software is provided to Arizona State University for the purpose
//  of grading and evaluation. This software is provided AS IS.
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
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
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
        
        
        guard let selectedPaths = tableView.indexPathsForSelectedRows else { return }
        
        let toPlace = places[selectedPaths[0].row]
        let fromPlace = places[selectedPaths[1].row]


        let toLocation = CLLocation(latitude: CLLocationDegrees(toPlace.latitude), longitude: CLLocationDegrees(toPlace.longitude))
        
        let fromLocation = CLLocation(latitude: CLLocationDegrees(fromPlace.latitude), longitude: fromPlace.longitude)
        
        let distance = toLocation.distance(from: fromLocation).magnitude
        let kilometers = String(format: "%.2f", distance/1000.0) + " kilometers"
        let heading = calculateBearing(with: toLocation, and: fromLocation)
        let formattedHeading = String(format: "%.4f", heading) + " degrees"
        
        let distanceModel = SphericalDistanceModel(toPlace: toPlace.addressTitle, fromPlace: fromPlace.addressTitle, distance: kilometers, heading: formattedHeading)
        displaySphericalDistance(with: distanceModel)
    }
    
    // The calculateBearing(with toPoint: CLLocation, and fromPoint: CLLocation),  degreesToRadians(degrees: Double) -> Double, and radiansToDegrees(radians: Double) -> Double were discovered on StackOverflow from the following link:
    // https://stackoverflow.com/questions/26998029/calculating-bearing-between-two-cllocation-points-in-swift
    // The funcions were modified to match the style of my code and to be more readable.
    // The algorithm is true to the stack overflow implementation which is why I included a reference to that code here.
    private func calculateBearing(with toPoint: CLLocation, and fromPoint: CLLocation) -> Double {
        let toLatitudeInRadians = degreesToRadians(degrees: toPoint.coordinate.latitude)
        let toLongitudeInRadians = degreesToRadians(degrees: toPoint.coordinate.longitude)
        
        let fromLatitudeInRadians = degreesToRadians(degrees: fromPoint.coordinate.latitude)
        let fromLongitudeInRadians = degreesToRadians(degrees: fromPoint.coordinate.longitude)
        let dLongitude = fromLongitudeInRadians - toLongitudeInRadians
        
        let x = sin(dLongitude) * cos(fromLatitudeInRadians)
        let y = cos(toLongitudeInRadians) * sin(fromLatitudeInRadians) - sin(toLatitudeInRadians) * cos(fromLatitudeInRadians) * cos(dLongitude)
        
        let bearingInRadians = atan2(y, x)
        let bearingInDegrees = radiansToDegrees(radians: bearingInRadians)
        
        return bearingInDegrees
        
    }
    
    //See above:
    //https://stackoverflow.com/questions/26998029/calculating-bearing-between-two-cllocation-points-in-swift
    private func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    private func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
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
        if let selectedPaths = tableView.indexPathsForSelectedRows {
            selectedPaths.forEach({ indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
            })
            selectedCells = [IndexPath]()
            print("Selected Cells: \(selectedCells)")
        }
        
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
