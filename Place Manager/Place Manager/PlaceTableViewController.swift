//
//  PlaceTableViewController.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/10/18.
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//

import UIKit

class PlaceTableViewController: UITableViewController {
    
    var places: [Place] = Places().places
    
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

    override func tableView(_ tableView: UITableView,
                            editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    let editPlace = "EditPlace"
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == editPlace {
            guard let indexPath = tableView.indexPathForSelectedRow,
            let addPlaceTableViewController = segue.destination as? AddPlaceTableViewController else { return }
        
            let place = places[indexPath.row]
            addPlaceTableViewController.place = place
        }
    }
 

}
