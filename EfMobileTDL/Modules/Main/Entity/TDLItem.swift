//
//  Task.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import Foundation

struct TDLItem: Equatable, Codable, Hashable {
    let id: Int
    var title: String
    var subtitle: String
    let date: String
    var completed: Bool
    
    static func == (lhs: TDLItem, rhs: TDLItem) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title && lhs.subtitle == rhs.subtitle && lhs.date == rhs.date && lhs.completed == rhs.completed
    }
    
    func getDate() -> Date {
        return DependencyContainer.dateFormatter.date(from: date) ?? Date.distantPast
    }
}
