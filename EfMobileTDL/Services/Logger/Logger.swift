//
//  Logger.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 27.08.2025.
//

import Foundation
import os

enum Log {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "EfMobileTDL"

    static let app = Logger(subsystem: subsystem, category: "App")
    static let coreData = Logger(subsystem: subsystem, category: "coreData")
    static let networkLayer = Logger(subsystem: subsystem, category: "networkLayer")
    static let main = Logger(subsystem: subsystem, category: "Main")
    static let addItem = Logger(subsystem: subsystem, category: "addItem")
    static let editItem = Logger(subsystem: subsystem, category: "editItem")

}

extension Logger {
    func debugOnly(_ message: @autoclosure @escaping () -> String,
               file: StaticString = #fileID,
               function: StaticString = #function,
               line: UInt = #line) {
#if DEBUG
        debug("\(file):\(line) \(function) — \(message(), privacy: .public)")
#endif
    }

    func errorAlways(_ message: @autoclosure @escaping () -> String,
               file: StaticString = #fileID,
               function: StaticString = #function,
               line: UInt = #line) {
        error("\(file):\(line) \(function) — \(message(), privacy: .public)")
    }
}
