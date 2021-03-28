//
//  StorageManager.swift
//  SimpleToDoList
//
//  Created by Marat on 22.03.2021.
//

import Foundation
import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "SimpleToDoList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}

    // MARK: - Public Methods
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print(error)
            return []
        }
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        let task = Task(context: viewContext)

        task.name = taskName
        completion(task)
        
        saveContext()
    }
    
    func edit(_ taskName: String, _ task: Task ) {        
        task.name = taskName
        saveContext()
    }
    
    func delete(_ task: Task) {
        viewContext.delete(task)
        
        saveContext()
    }
    
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
