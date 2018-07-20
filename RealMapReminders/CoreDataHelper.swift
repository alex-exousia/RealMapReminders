//
//  CoreDataHelper.swift
//  RealMapReminders
//
//  Created by Alexander Niehaus on 7/18/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import CoreData
import Foundation

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newReminder() -> Reminder {
        let reminder = NSEntityDescription.insertNewObject(forEntityName: "Reminder", into: context) as! Reminder
        return reminder
    }
    
    static func saveReminder() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func deleteReminder(reminder: Reminder) {
        context.delete(reminder)
        saveReminder()
    }
    
    static func retrieveReminders() -> [Reminder] {
        let fetchRequest = NSFetchRequest<Reminder>(entityName: "Reminder")
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            return []
        }
    }
    
    static func newLocation() -> Location {
        let location = NSEntityDescription.insertNewObject(forEntityName: "Location", into:context) as! Location
        return location
    }
    static func saveLocation() {
        do {
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
            
        }
    }
    
    static func retrieveLocation() -> [Location] {
        do {
            let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
            let results = try context.fetch(fetchRequest)
            //let sorted = results.sorted { (first, second) -> Bool in
            //  return first.modificationTime! > second.modificationTime!
            print("\n\n\nfetching request\n")
//            print ("\(fetchRequest)")
//            print ("\(results)")
            print(results.count)
            print(results[0].longToSave)
            print(results[0].latToSave)
            
        }
            //return sorted
        catch let error {
            print ("Could not fetch \(error.localizedDescription)")
        }
        return []
    }
}

