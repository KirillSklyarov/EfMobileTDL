//
//  AppStorage.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import Foundation

final class AppStorage {

    private(set) var userTasks: [TaskOld] = []

    func setUserTasks(_ tasks: [TaskOld]) {
        self.userTasks = tasks
    }

}
