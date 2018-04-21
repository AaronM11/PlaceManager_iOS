//
//  Place.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/10/18.
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//

import Foundation

struct Place {
    
    let name: String
    let description: String
    let category: String
    let addressTitle: String
    let addressStreet: String
    let elevation: Double
    let latitude: Double
    let longitude: Double

    init(name: String, description: String, category: String, addressTitle: String, addressStreet: String, elevation: Double, latitude: Double, longitude: Double) {
        self.name = name
        self.description = description
        self.category = category
        self.addressTitle = addressTitle
        self.addressStreet = addressStreet
        self.elevation = elevation
        self.latitude = latitude
        self.longitude = longitude
    }

}
