//
//  PlaceDB.swift
//  Place Manager
//
//  Created by Aaron Musengo on 4/10/18.
//  Email: amuseng1@asu.edu
//  Copyright © 2018 Aaron Musengo. All rights reserved.
//  This software is provided to Arizona State University for the purpose
//  of grading and evaluation. This software is provided AS IS.
//

import Foundation
import UIKit
import CoreData

public class PlaceDB {
    var appDelegate: AppDelegate?
    var managedContext: NSManagedObjectContext?
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func getPlaces() -> [Place]? {
        let fetchPlaces: NSFetchRequest<Place> =  Place.fetchRequest()
        do {
            guard let results = try managedContext?.fetch(fetchPlaces) else { return nil }
            return results
        } catch let error as NSError {
            print("Error selecting all places: \(error)")
        }
        return nil
    }
    
    @discardableResult
    func addPlace(place: PlaceWrapper) -> Bool {
        var added: Bool = false
        guard let managedContext = managedContext,
            let entity = NSEntityDescription.entity(forEntityName: "Place", in: managedContext) else { return added }
        let placeMO = NSManagedObject(entity: entity, insertInto: managedContext)
        
        placeMO.setValue(place.addressStreet, forKey: "addressStreet")
        placeMO.setValue(place.addressTitle, forKey: "addressTitle")
        placeMO.setValue(place.category, forKey: "category")
        placeMO.setValue(place.description, forKey: "detail")
        placeMO.setValue(place.elevation, forKey: "elevation")
        placeMO.setValue(place.latitude, forKey: "latitude")
        placeMO.setValue(place.longitude, forKey: "longitude")
        placeMO.setValue(place.name, forKey: "name")
        added = true
        return added
    }
    
    func placeExists(for placeName: String) -> Bool {
        let selectRequest: NSFetchRequest<Place> = Place.fetchRequest()
        selectRequest.predicate = NSPredicate(format: "name == %@", placeName)
        do {
            guard let results = try managedContext?.fetch(selectRequest) else { return false }
             if results.count > 0 {
                return true
            }
        } catch let error as NSError {
            NSLog("Error selecting place \(placeName). Error: \(error)")
        }
        return false
    }
    
    func getPlace(for placeName: String) -> Place? {
        let fetchPlace: NSFetchRequest<Place> = Place.fetchRequest()
        fetchPlace.predicate = NSPredicate(format: "name == %@", placeName)
        do {
            guard let results = try managedContext?.fetch(fetchPlace) else { return nil }
            if results.count > 0 {
                return results[0]
            }
        } catch let error as NSError{
            NSLog("error getting palce \(placeName), error \(error)")
        }
        return nil
    }
    
    @discardableResult
    func deletePlace(name: String) -> Bool {
        let selectRequest:NSFetchRequest<Place> = Place.fetchRequest()
        selectRequest.predicate = NSPredicate(format:"name == %@",name)
        do{
            guard let results = try managedContext?.fetch(selectRequest) else { return false }
            
            if results.count > 0 {
                managedContext?.delete(results[0] as NSManagedObject)
                return true
            }
        } catch let error as NSError{
            NSLog("error deleting place \(name). Error \(error)")
        }
        
        return false
    }
    
    @discardableResult
    func saveContext() -> Bool {
        var saved = false
        do{
            try managedContext!.save()
            saved = true
        }catch let error as NSError{
            print("error saving context \(error)")
        }
        return saved
    }

}
