//
//  Place.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/10/18.
//  Email: amuseng1@asu.edu
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//  This software is provided to Arizona State University for the purpose
//  of grading and evaluation. This software is provided AS IS.
//

import Foundation

//Wrapper for a Place object.
struct PlaceWrapper: Codable {
    
    let name: String
    let description: String
    let category: String
    let addressTitle: String
    let addressStreet: String
    let elevation: Double
    let latitude: Double
    let longitude: Double
    
    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case category
        case addressTitle = "address-title"
        case addressStreet = "address-street"
        case elevation
        case latitude
        case longitude
    }

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
