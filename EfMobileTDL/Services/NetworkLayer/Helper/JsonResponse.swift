//
//  JsonResponce.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import Foundation

struct JsonResponse: Codable {
    let todos: [ToDoItem]
    let total: Int
    let skip: Int
    let limit: Int
}

struct ToDoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int

    func getDate() -> String {
        return DependencyContainer.dateFormatter.string(from: Date())
    }

    func toTask() -> TDLItem {
        TDLItem(id: id, title: "1", subtitle: todo, date: getDate(), completed: completed)
    }
}
