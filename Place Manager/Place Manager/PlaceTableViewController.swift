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
    
    var places: [Place] = Places().places
    var selectedIndexPath: IndexPath?
    
    var selectedCells: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
//        navigationItem.rightBarButtonItem = plusBarBu
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //  only 1 section.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeTableViewCell", for: indexPath)
        
        let place = places[indexPath.row]

        cell.textLabel?.text = place.name
        cell.detailTextLabel?.text = place.addressTitle

        return cell
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
        
        if let place = sourceViewController.place {
            if let selectedIndexPath = selectedIndexPath {
                places[selectedIndexPath.row] = place
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: places.count, section: 0)
                places.append(place)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        selectedIndexPath = nil
    }
    
}
