//
//  Place+CoreDataProperties.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/26/18.
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//
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
