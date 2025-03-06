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
    private let router: AppRouter
    private let coreDataManager: CoreDataManager

    private var window: UIWindow?
    private var mainViewController: MainViewController?
    private var rootNavigationController: UINavigationController?

    private let userDefaults = UserDefaults.standard
    private var data: [TDLItem] = []

    // MARK: - Init
    init(storage: AppStorage, networkService: NetworkService, router: AppRouter, coreDataManager: CoreDataManager) {
        self.storage = storage
        self.networkService = networkService
        self.router = router
        self.coreDataManager = coreDataManager
    }

    // MARK: - Public methods
    func startApp() {
        showRootVC()
        mainViewController?.loading()

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
        let isFirstLaunch = !userDefaults.bool(forKey: "hasLaunchedBefore")

        do {
            try await fetchDataIsFirstLaunch(isFirstLaunch)
            await updateVC()
        } catch {
            await setVCErrorState()
            print(error)
        }
    }

    func updateVC() async {
        await MainActor.run {
            mainViewController?.configure(with: data)
            print("Done")
        }
    }

    func setVCErrorState() async {
        await MainActor.run {
            mainViewController?.error()
        }
    }

    func fetchDataIsFirstLaunch(_ isFirstLaunch: Bool) async throws {
        if isFirstLaunch {
            data = try await networkService.fetchDataFromServer()
            print("Data fetched from server")
            userDefaults.set(true, forKey: "hasLaunchedBefore")
            coreDataManager.saveDataInCoreData(tdlItems: data)
        } else {
            data = coreDataManager.getCorrectDataFromCoreData()
            print("Data fetched from CoreData")
        }

        storage.setUserTasks(data)
    }
}

private extension AppStartManager {
    func showRootVC() {
        mainViewController = MainViewController(storage: storage, router: router)
        setupRootNavigation()
        showRootScreen()
    }

    func setupRootNavigation() {
        guard let mainViewController else { print("No mainViewController"); return }
        rootNavigationController = router.setupRootViewController(with: mainViewController)
    }

    func showRootScreen() {
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}
