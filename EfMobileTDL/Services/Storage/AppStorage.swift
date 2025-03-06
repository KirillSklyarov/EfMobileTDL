//
//  AppStorage.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import Foundation

final class AppStorage {
    private(set) var data: [TDLItem] = []

    let queue = DispatchQueue(label: "efmobile.tdl.appstorage", qos: .userInteractive)
}

// MARK: - CRUD
extension AppStorage {
    func getData(completion: @escaping ([TDLItem]) -> Void) {
        queue.async { [weak self] in
            guard let self else { completion([]); return }
            completion(data)
        }
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

    func removeTask(_ task: TDLItem) {
        queue.async { [weak self] in
            self?.data.removeAll { $0 == task }
        }
    }

    func changeTaskState(_ task: TDLItem) {
        queue.async { [weak self] in
            guard let self else { return }
            guard let index = data.firstIndex(where: { $0 == task }) else { print("Task not found"); return }
            data[index].completed.toggle()
            print(data[index])
        }
    }
}
