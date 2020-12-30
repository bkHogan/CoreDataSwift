//
//  PersistenceService.swift
//  CoreDataAssignment
//
//  Created by Field Employee on 12/29/20.
//

import Foundation
import CoreData

class PersistenceService {
    
    private init() {}
    static let shared = PersistenceService()
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "CoreDataAssignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Sucessfully saved")
                
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        
        do{
            let objects = try context.fetch(request)
            completion(objects)
        }catch{
            print(error)
            completion([])
        }
        
    }
}
