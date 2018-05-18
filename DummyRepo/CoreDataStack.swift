//
//  CoreDataStack.swift
//  DummyRepo
//
//  Created by Mac O'brien on 5/18/18.
//  Copyright © 2018 Richard Blanchard. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createStockEntity() -> StockEntity? {
        let stockEntity = StockEntity(context: managedObjectContext)
        
        return nil
    }


    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DummyRepo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
