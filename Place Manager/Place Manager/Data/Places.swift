//
//  Places.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/21/18.
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//

import Foundation

public enum Category: String {
    case travel = "Travel"
    case school = "School"
    case hike = "Hike"
}

struct Places {
    var places: [Place]
    
    init() {
        places = [
            Place(name: "ASU-West", description: "Home of ASU's Applies Computing Program", category: "School", addressTitle: "ASU West Campus", addressStreet: "1351 N 47th Ave, Phoenix AZ 85051", elevation: 1100.0, latitude: 33.608979, longitude: -112.159469),
            Place(name: "UAK-Anchorage", description: "University of Alaska's largest campus", category: "School", addressTitle: "University of Alaska at Anchorage", addressStreet: "290 Spirit Drive, Anchorage AK 99508", elevation: 0.0, latitude: 61.189748, longitude: -149.826721),
            Place(name: "Toreros", description: "The only real way in and out of Barrow Alaska", category: "Travel", addressTitle: "Will Rodgers Airport", addressStreet: "1725 Ahkovak St, Barrow AK 99723", elevation: 5.0, latitude: 71.287881, longitude: -156.779417),
            Place(name: "Windcave-Peak", description: "Beyond the Wind Cave is a half mile trail with 250 feet additional elevation to the peak overlooking Usery and the Valley", category: "Hike", addressTitle: "Usery Mountain Recreation Area", addressStreet: "3939 N Usery Pass Rd, Mesa AZ 85207", elevation: 3130.0, latitude: 33.476069, longitude: -111.595709),
            Place(name: "Notre-Dame-Paris", description: "The 13th century cathedral with gargoyles, one of the first flying buttress, and home of the purported crown of thorns.", category: "Travel", addressTitle: "Cathedral Notre Dame de Paris", addressStreet: "6 Parvis Notre-Dame Pl Jean-Paul-II, 75004 Paris France", elevation: 115.0, latitude: 48.852972, longitude: 2.349910),
            Place(name: "Moscow-Russia", description: "The Marriott Courtyard in downtown Moscow", category: "Travel", addressTitle: "Courtyard Moscow City Center", addressStreet: "Voznesenskiy per 7, Moskva Russia 125009", elevation: 512.0, latitude: 55.758666, longitude: 37.604058),
            Place(name: "London-England", description: "Renaissance Hotel at the Heathrow Airport", category: "Travel", addressTitle: "Renaissance London Heathrow Airport", addressStreet: "5 Mondial Way, Harlington Hayes UB3 UK", elevation: 82.0, latitude: 51.481959, longitude:  -0.445286)
        ]
    }

}
