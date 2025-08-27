//
//  CoreDataManager.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func getItemToEdit() -> TDLItem?
    func setItemToEdit(_ item: TDLItem)

    func updateItem(_ item: TDLItem)
    func addNewItem(_ item: TDLItem)
    func saveDataInCoreData(tdlItems: [TDLItem])
    func fetchData(_ context: NSManagedObjectContext?) -> [TDL]
    func removeItem(_ item: TDLItem, completion: (() -> Void)?)
}


final class CoreDataManager: CoreDataManagerProtocol {
    private(set) var itemToEdit: TDLItem?

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EfMobileTDL")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                Log.coreData.errorAlways("Core Data loading error: \(error), \(error.userInfo)")
            } else {
                Log.coreData.debugOnly(AppConstants.L.coreDataLoaded())
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func createBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
}

// MARK: - CRUD
extension CoreDataManager {
    func saveDataInCoreData(tdlItems: [TDLItem]) {
        let backgroundContext = createBackgroundContext()

        backgroundContext.perform { [weak self] in
            guard let self else { Log.coreData.errorAlways("self is nil"); return }
            let existingItems = fetchData(backgroundContext)
            let existingItemsDict = getExistingItemsIds(from: existingItems)

            for item in tdlItems {
                if existingItemsDict[item.id] != nil {
                    updateItem(item)
                } else {
                    createNewItem(from: item, context: backgroundContext, isTracking: false)
                }
            }
            saveContext(backgroundContext)
        }
    }

    func fetchData(_ context: NSManagedObjectContext? = nil) -> [TDL] {
        let context = context ?? self.context
        let fetchRequest = TDL.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            Log.coreData.errorAlways("Core Data fetch error: \(error.localizedDescription)")
            return []
        }
    }

    func updateItem(_ item: TDLItem) {
        let backgroundContext = createBackgroundContext()

        backgroundContext.perform { [weak self] in
            guard let self,
                  let task = getTask(with: item.id, context: backgroundContext) else {
                Log.coreData.errorAlways("No task found"); return }

            let needsUpdate = isNeedUpdate(task, with: item)

            if needsUpdate {
                update(task: task, with: item)
                saveContext(backgroundContext)
            } else {
                Log.coreData.debugOnly(AppConstants.L.dataNotChanged())
            }
        }
    }

    func addNewItem(_ item: TDLItem) {
        let backgroundContext = createBackgroundContext()

        backgroundContext.perform { [weak self] in
            guard let self else { Log.coreData.errorAlways("self is nil"); return }
            createNewItem(from: item, context: backgroundContext)
            saveContext(backgroundContext)
        }
    }

    func removeItem(_ item: TDLItem, completion: (() -> Void)?) {
        let backgroundContext = createBackgroundContext()

        backgroundContext.perform { [weak self] in
            guard let self,
                  let task = getTask(with: item.id, context: backgroundContext) else {
                Log.coreData.errorAlways("Task not found"); return }

            backgroundContext.delete(task)
            Log.coreData.debugOnly(AppConstants.L.taskRemoved())
            saveContext(backgroundContext)
            completion?()
        }
    }

    func setItemToEdit(_ item: TDLItem) {
        itemToEdit = item
    }

    func getItemToEdit() -> TDLItem? {
        itemToEdit
    }
}

// MARK: - Save context
extension CoreDataManager {
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                Log.coreData.debugOnly(AppConstants.L.contextOK())
            } catch {
                let nserror = error as NSError
                Log.coreData.errorAlways("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Supporting methods
private extension CoreDataManager {
    func getTask(with id: Int, context: NSManagedObjectContext) -> TDL? {
        let fetchRequest = TDL.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", Int64(id))
        fetchRequest.fetchLimit = 1

        do {
            let task = try context.fetch(fetchRequest)
            return task.first
        } catch {
            Log.coreData.errorAlways("Get task error: \(error.localizedDescription)")
            return nil
        }
    }

    func deleteAll() {
        let backgroundContext = createBackgroundContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TDL")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform { [weak self] in
            guard let self else { Log.coreData.errorAlways("self is nil"); return }

            do {
                try backgroundContext.execute(deleteRequest)
                saveContext(backgroundContext)

                DispatchQueue.main.async {
                    self.context.reset()
                }
            } catch {
                Log.coreData.errorAlways("Delete all error: \(error.localizedDescription)")
            }
        }
    }

    func isNeedUpdate(_ tdlObject: TDL, with item: TDLItem) -> Bool {
        return !areEqual(tdlObject, item)
    }

    func areEqual(_ lhs: TDL, _ rhs: TDLItem) -> Bool {
        let title = lhs.title ?? ""
        let subtitle = lhs.subtitle ?? ""
        return title == rhs.title &&
               subtitle == rhs.subtitle &&
               lhs.date == rhs.date &&
               lhs.completed == rhs.completed
    }

    func update(task: TDL, with item: TDLItem) {
        task.title = item.title
        task.subtitle = item.subtitle
        task.date = item.date
        task.completed = item.completed
        Log.coreData.debugOnly(AppConstants.L.taskUpdated())
    }

    func getExistingItemsIds(from existingItems: [TDL]) -> [Int: TDL] {
        var existingItemsDict: [Int: TDL] = [:]
        for item in existingItems {
            existingItemsDict[Int(item.id)] = item
        }
        return existingItemsDict
    }

    func createNewItem(from item: TDLItem, context: NSManagedObjectContext, isTracking: Bool = true) {
        let newItem = TDL(context: context)
        newItem.id = Int64(item.id)
        newItem.title = item.title
        newItem.subtitle = item.subtitle
        newItem.date = item.date
        newItem.completed = item.completed
        if isTracking {
            Log.coreData.debugOnly(AppConstants.L.newTaskAdded())
        }
    }
}
