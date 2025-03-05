//
//  Task.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import Foundation

struct TDL: Equatable, Codable {
    let id: Int
    var title: String
    var subtitle: String
    let date: String
    var completed: Bool
    
    static func == (lhs: TDL, rhs: TDL) -> Bool {
        return lhs.id == rhs.id
    }
    
    func getDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.date(from: date) ?? Date.distantPast
    }
}
