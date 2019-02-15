//
//  MagazineServices.swift
//  HuaFeng
//
//  Created by Zhijie Chen on 8/9/18.
//  Copyright © 2018 Zhijie Chen. All rights reserved.
//

import CoreData
import UIKit

class MagazineService {
    // MARK: Initialization
    private init() {
        let container = NSPersistentContainer(name: "HuafengMagazine")
        persistentContainer = container

        container.viewContext.automaticallyMergesChangesFromParent = true
        
        //Mark: Writers
        let writerNamesDataURL = Bundle.main.url(forResource: "WriterName", withExtension: "plist")!
        let writerNamesData = try! Data(contentsOf: writerNamesDataURL)
        let writerNames = try! PropertyListSerialization.propertyList(from: writerNamesData, options: [], format: nil) as! Array<Dictionary<String, Any>>
        
        //MARK: Magazine
        let magValuesDataURL = Bundle.main.url(forResource: "Magazines", withExtension: "plist")!
        let magValuesData = try! Data(contentsOf: magValuesDataURL)
        let magValues = try! PropertyListSerialization.propertyList(from: magValuesData, options: [], format: nil) as! Array<Dictionary<String, Any>>

        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let someError = error as NSError? {
                fatalError("Error loading persistent store \(someError)")
            }
            
            let context = self.persistentContainer.viewContext
            
            context.performAndWait {
                let fetchRequest: NSFetchRequest<Writer> = Writer.fetchRequest()
                let count = try! context.count(for: fetchRequest)
                guard count == 0 else {
                    return
                }
                var writers : [Writer] = []
                
                for writernameOfPlist in writerNames {
                    let writer = Writer(context: context)
                    
                    writer.writername = writernameOfPlist["writername"] as? String
                    writer.writerposition = writernameOfPlist["writerposition"] as? String
                    writers.append(writer)
                }
                
                for magazineOfPlist in magValues {
                    let magazine = Magazine(context: context)
                    magazine.magPics = magazineOfPlist["magPics"] as? String
                    magazine.magTitle = magazineOfPlist["magTitle"] as? String
                    magazine.magSubtitle = magazineOfPlist["magSubtitle"] as? String
                    magazine.magazineName = magazineOfPlist["magazineName"] as? String
                    
                    if let writersIds = (magazineOfPlist["magWriters"] as? Array<Int>) {
                        for id in writersIds {
                            magazine.addToWriter(writers[id])
                        }
                    }
                    
                }
                
                try! context.save()
            }
        
        })
    }

    
    // MARK: Properties (Private)
    private let persistentContainer: NSPersistentContainer
    
    // MARK: Properties (Static Constant)
    static let shared = MagazineService()

    // MARK: Private
    private func fetchedResultsController<T>(for fetchRequest: NSFetchRequest<T>) -> NSFetchedResultsController<T> where T: NSManagedObject {
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        try! fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
    
    // MARK: Add
    @discardableResult
    func addShelf(withName name: String, andOrderIndex orderIndex: Int32) throws -> Shelf{
        let context = persistentContainer.viewContext
        let shelf = Shelf(context: context)
        shelf.name = name
        shelf.weight = orderIndex

        try context.save()
        return shelf
    }
    
    // MARK: Rename
    func renameShelf(_ shelf: Shelf, withNewName newName: String) throws {
        shelf.name = newName
        let context = persistentContainer.viewContext
        try context.save()
    }

    // MARK: Delete
    func deleteShelf(_ shelf: Shelf) throws {
        let context = persistentContainer.viewContext
        context.delete(shelf)
        try context.save()
    }
    
    // MARK: Reindex
    func reindex(_ shelves: Array<Shelf>, shiftForward: Bool) throws {
        for shelf in shelves {
            let currentOrderIndex = shelf.weight
            if shiftForward {
                shelf.weight = (currentOrderIndex + 1)
            }
            else {
                shelf.weight = (currentOrderIndex - 1)
            }
        }
        
        let context = persistentContainer.viewContext
        try context.save()
    }
    
    // MARK: Service
    func Shelves() -> NSFetchedResultsController<Shelf> {
        let fetchRequest: NSFetchRequest<Shelf> = Shelf.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "weight", ascending: true)]
        fetchRequest.fetchBatchSize = 15
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func Magzines() -> NSFetchedResultsController<Magazine> {
        let fetchRequest: NSFetchRequest<Magazine> = Magazine.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "magSubtitle", ascending: true)]
        fetchRequest.fetchBatchSize = 15
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func Writers() -> NSFetchedResultsController<Writer> {
        let fetchRequest: NSFetchRequest<Writer> = Writer.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "writername", ascending: true)]
        fetchRequest.fetchBatchSize = 15
        
        return fetchedResultsController(for: fetchRequest)
    }
    
    func save() {
        let context = persistentContainer.viewContext
        try! context.save()
    }
    
    
}
    

