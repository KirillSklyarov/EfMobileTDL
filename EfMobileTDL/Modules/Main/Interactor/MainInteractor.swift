//
//  MainInteractor.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol MainInteractorInput: AnyObject {
    func getData(completion: @escaping ([TDLItem]) -> Void)
    func setUserTasks(_ tasks: [TDLItem])
    func addTask(_ newTask: TDLItem)
    func removeTask(_ task: TDLItem)
    func updateTask(_ task: TDLItem, at index: Int)
    func editTask(_ newTask: TDLItem, index: Int)
    func filterData(by string: String) -> [TDLItem]
    func changeTaskState(_ task: TDLItem)
    func getIndex(of task: TDLItem) -> Int?
    func fetchData() async
    func selectItemForEditing(_ item: TDLItem)
    func getNewDataFromCD()
}


final class MainInteractor {
    private let dataManager: CoreDataManagerProtocol
    private let networkService: NetworkService
    weak var output: MainViewOutput?

    private(set) var data: [TDLItem] = []

    private let queue = DispatchQueue(label: "efmobile.tdl.appstorage", qos: .userInteractive)

    private let userDefaults = UserDefaults.standard

    init(dataManager: CoreDataManagerProtocol, networkService: NetworkService) {
        self.dataManager = dataManager
        self.networkService = networkService
    }
}

extension MainInteractor: MainInteractorInput {
    func selectItemForEditing(_ item: TDLItem) {
        dataManager.setItemToEdit(item)
    }
    
    func fetchData() async {
        let isFirstLaunch = !userDefaults.bool(forKey: "hasLaunchedBefore")

        do {
            try await fetchDataIsFirstLaunch(isFirstLaunch)
        } catch {
            output?.getError()
            print(error.localizedDescription)
        }
    }

    func fetchDataIsFirstLaunch(_ isFirstLaunch: Bool) async throws {
        if isFirstLaunch {
            data = try await networkService.fetchDataFromServer()
            print("🌐 Data fetched from server")
            userDefaults.set(true, forKey: "hasLaunchedBefore")
            dataManager.saveDataInCoreData(tdlItems: data)
        } else {
            getNewDataFromCD()
            print("📦 Data fetched from CoreData")
        }
    }

    func changeTaskState(_ task: TDLItem) {
        queue.async { [weak self] in
            guard let self else { return }
            var newStatusTask = task
            newStatusTask.completed.toggle()
            dataManager.updateItem(newStatusTask)
        }
    }

    func getNewDataFromCD() {
        data = getCorrectDataFromCoreData()
        output?.dataLoaded(data)
    }

    func removeTask(_ task: TDLItem) {
        queue.async { [weak self] in
            guard let self else { return }
            dataManager.removeItem(task)
            getNewDataFromCD()
        }
    }
}

// MARK: - CRUD
extension MainInteractor {
    
    func getData(completion: @escaping ([TDLItem]) -> Void) {
        queue.async { [weak self] in
            guard let self else { completion([]); return }
            completion(data)
        }
    }

    func getIndex(of task: TDLItem) -> Int? {
        return data.firstIndex { $0 == task }
    }

    func setUserTasks(_ tasks: [TDLItem]) {
        self.data = tasks
    }

    func addTask(_ newTask: TDLItem) {
        queue.async { [weak self] in
            self?.data.append(newTask)
            self?.sortDataByDate()
        }
    }

    func filterData(by string: String) -> [TDLItem] {
        if string.isEmpty {
            return data
        } else {
            let filteredData = data.filter { $0.subtitle.lowercased().contains(string.lowercased()) }
            return filteredData
        }
    }

    func sortDataByDate() {
        data.sort { $0.getDate() > $1.getDate() }
    }

    func editTask(_ newTask: TDLItem, index: Int) {
        queue.async { [weak self] in
            self?.data[index] = newTask
        }
    }

    func updateTask(_ task: TDLItem, at index: Int) {
//
    }
}

// MARK: - Supporting methods
private extension MainInteractor {
    func getCorrectDataFromCoreData() -> [TDLItem] {
        let data = dataManager.fetchData()
        return dataMapping(data)
    }

    func dataMapping(_ items: [TDL]) -> [TDLItem] {
        let array = items.compactMap { item in
            return TDLItem(id: Int(item.id),
                           title: item.title ?? "",
                           subtitle: item.subtitle ?? "",
                           date: item.date ?? "",
                           completed: item.completed)
        }

        return sortData(array)
    }

    // Сортируем массив по датам
    func sortData(_ items: [TDLItem]) -> [TDLItem] {
        return items.sorted { $0.getDate() > $1.getDate() }
    }
}
