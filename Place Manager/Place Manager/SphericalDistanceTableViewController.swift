//
//  SpehericalDistanceTableViewController.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/25/18.
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//

import UIKit

class SphericalDistanceTableViewController: UITableViewController {
    
    var model: SphericalDistanceModel?
    
    // MARK: - Private IBOutlets
    
    @IBOutlet weak var toPlaceTextField: UITextField!
    @IBOutlet weak var fromPlaceTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var headingTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let model = model {
            toPlaceTextField.text = model.toPlace
            fromPlaceTextField.text = model.fromPlace
            distanceTextField.text = model.distance
            headingTextField.text = model.heading
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
