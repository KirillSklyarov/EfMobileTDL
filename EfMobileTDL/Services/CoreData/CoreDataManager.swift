//
//  CoreDataManager.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func updateTaskInCoreData(_ item: TDLItem)
}

final class CoreDataManager {

    private(set) var itemToEdit: TDLItem?

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EfMobileTDL")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("🔴 Unresolved error \(error), \(error.userInfo)")
            } else {
                print("✅ CoreDate upload successfully")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

// MARK: - CRUD
extension CoreDataManager {
    // Метод для сохранения данных из AppStorage в CoreData
    func saveDataInCoreData(tdlItems: [TDLItem]) {
        let existingItems = getAllTDL()
        let existingItemsDict = getExistingItemsIds(from: existingItems)

        for item in tdlItems {
            if existingItemsDict[item.id] != nil {
                updateTask(item)
            } else {
                createTDL(from: item)
            }
        }

        saveContext()
        printAllTDL()
    }

    func setItemToEdit(_ item: TDLItem) {
        itemToEdit = item
        print(itemToEdit ?? "ItemToEdit is nil")
    }

    func getItemToEdit() -> TDLItem? {
        itemToEdit
    }

    // Обновление данных в coreData
    func updateTask(_ item: TDLItem) {
        guard let task: TDL = getTask(with: item.id) else { print("Ooops"); return }

        // Проверка, изменились ли данные
        let needsUpdate = isNeedUpdate(task, with: item)

        if needsUpdate {
            task.title = item.title
            task.subtitle = item.subtitle
            task.date = item.date
            task.completed = item.completed
            print("✅ Запись успешно обновлена")
        }
        saveContext()
    }

    // Создание нового объекта TDL в CoreData
    func createTDL(from item: TDLItem) {
        let tdlObject = TDL(context: context)
        tdlObject.id = Int64(item.id)
        tdlObject.title = item.title
        tdlObject.subtitle = item.subtitle
        tdlObject.date = item.date
        tdlObject.completed = item.completed
    }


    func printAllTDL() {
        let fetchRequest = TDL.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)

            if results.isEmpty {
                print("📭 Core Data пуста - нет данных TDL")
            } else {
                print("📋 Данные из Core Data (\(results.count) записей)")
            }
        } catch {
            print("❌ Ошибка при получении данных: \(error.localizedDescription)")
        }
    }

    func getCorrectDataFromCoreData() -> [TDLItem] {
        let allTDL = getAllTDL()
        return dataMapping(allTDL)
    }

    func getTask(with id: Int) -> [TDLItem]? {
        let fetchRequest = TDL.fetchRequest()

        do {
            let allData = try context.fetch(fetchRequest)
            let task = allData.filter { $0.id == Int64(id) }
            return dataMapping(task)
        } catch {
            print("❌ Ошибка при поиске объекта по ID: \(error.localizedDescription)")
            return nil
        }
    }

    func getTask(with id: Int) -> TDL? {
        let fetchRequest = TDL.fetchRequest()

        do {
            let allData = try context.fetch(fetchRequest)
            let task = allData.filter { $0.id == Int64(id) }.first
            return task
        } catch {
            print("❌ Ошибка при поиске объекта по ID: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - Cleanup duplicates
extension CoreDataManager {
    func removeDuplicates() {
        let fetchRequest = TDL.fetchRequest()

        do {
            // Получаем все объекты
            let allItems = try context.fetch(fetchRequest)
            print("📊 Всего записей до очистки: \(allItems.count)")

            // Создаем словарь для отслеживания уникальных ID
            var uniqueIds: [Int64: TDL] = [:]
            var duplicatesToRemove: [TDL] = []

            // Находим дубликаты
            for item in allItems {
                if uniqueIds[item.id] != nil {
                    // Решаем, какой элемент оставить (например, по дате создания или другим критериям)
                    // В этом примере просто оставляем первый найденный элемент
                    duplicatesToRemove.append(item)
                } else {
                    // Сохраняем первое вхождение элемента с этим ID
                    uniqueIds[item.id] = item
                }
            }

            // Удаляем дубликаты
            for duplicate in duplicatesToRemove {
                context.delete(duplicate)
            }

            // Сохраняем изменения
            if !duplicatesToRemove.isEmpty {
                try context.save()
                print("🧹 Удалено дубликатов: \(duplicatesToRemove.count)")
                print("✅ Осталось уникальных записей: \(uniqueIds.count)")
            } else {
                print("✅ Дубликатов не найдено")
            }

        } catch {
            print("❌ Ошибка при удалении дубликатов: \(error.localizedDescription)")
        }
    }
}

// MARK: - Save context
extension CoreDataManager {
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                print("✅ Context added successfully")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Supporting methods
private extension CoreDataManager {
    func isNeedUpdate(_ tdlObject: TDL, with item: TDLItem) -> Bool {
        return !areEqual(tdlObject, item)
    }

    func areEqual(_ lhs: TDL, _ rhs: TDLItem) -> Bool {
        return lhs.title == rhs.title &&
               lhs.subtitle != rhs.subtitle &&
               lhs.date != rhs.date &&
               lhs.completed != rhs.completed
    }

    func getExistingItemsIds(from existingItems: [TDL]) -> [Int: TDL] {
        var existingItemsDict: [Int: TDL] = [:]
        for item in existingItems {
            existingItemsDict[Int(item.id)] = item
        }
        return existingItemsDict
    }

    func dataMapping(_ items: [TDL]) -> [TDLItem] {
        return items.compactMap { item in
            return TDLItem(id: Int(item.id),
                           title: item.title ?? "",
                           subtitle: item.subtitle ?? "",
                           date: item.date ?? "",
                           completed: item.completed)
        }
    }

    // Получить все объекты TDL в виде массива
    func getAllTDL() -> [TDL] {
        let fetchRequest = TDL.fetchRequest()

        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("❌ Ошибка при получении данных: \(error.localizedDescription)")
            return []
        }
    }
}
