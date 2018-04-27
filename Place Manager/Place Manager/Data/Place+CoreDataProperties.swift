//
//  Place+CoreDataProperties.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/10/18.
//  Email: amuseng1@asu.edu
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//  This software is provided to Arizona State University for the purpose
//  of grading and evaluation. This software is provided AS IS.
//

import Foundation
import CoreData

extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var addressStreet: String?
    @NSManaged public var addressTitle: String?
    @NSManaged public var category: String?
    @NSManaged public var detail: String?
    @NSManaged public var elevation: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    
}
