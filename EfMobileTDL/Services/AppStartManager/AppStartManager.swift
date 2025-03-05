//
//  AppStartManager.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import UIKit

final class AppStartManager {

    private let storage: AppStorage
    private let networkService: NetworkService
    private var window: UIWindow?

    // MARK: - Init
    init(storage: AppStorage, networkService: NetworkService) {
        self.storage = storage
        self.networkService = networkService
    }

    // MARK: - Public methods
    func startApp() {
        showRootVC()
        Task { await fetchData() }
    }
    // Принимаем окно из SceneDelegate
    func setWindow(_ window: UIWindow?) {
        self.window = window
    }
}

// MARK: - Fetch Data
private extension AppStartManager {
    func fetchData() async {
        do {
            let isFirstLaunch = !UserDefaults.standard.bool(forKey: "notFirstLaunch")
            try await fetchDataIsFirstLaunch(isFirstLaunch)
        } catch {
            print(error)
        }
    }

    func fetchDataIsFirstLaunch(_ isFirstLaunch: Bool) async throws {
        var data: [TaskOld] = []
        if isFirstLaunch {
            data = try await networkService.fetchDataFirstTime()
            UserDefaults.standard.set(true, forKey: "notFirstLaunch")
        } else {
            data = try await networkService.fetchData()
        }

        storage.setUserTasks(data)
        print(storage.userTasks)
    }
}

private extension AppStartManager {
    func showRootVC() {
        let mainViewController = MainViewController(storage: storage)
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        window?.makeKeyAndVisible()
    }
}
