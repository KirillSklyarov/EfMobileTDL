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
    private var mainViewController: MainViewController?

    private var data: [TDL] = []

    // MARK: - Init
    init(storage: AppStorage, networkService: NetworkService) {
        self.storage = storage
        self.networkService = networkService
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
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "notFirstLaunch")

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
            data = try await networkService.fetchDataFirstTime()
            UserDefaults.standard.set(true, forKey: "notFirstLaunch")
        } else {
            data = try await networkService.fetchData()
        }

        storage.setUserTasks(data)
//        print(storage.data)
    }
}

private extension AppStartManager {
    func showRootVC() {
        mainViewController = MainViewController(storage: storage)
        window?.rootViewController = UINavigationController(rootViewController: mainViewController!)
        window?.makeKeyAndVisible()
    }
}
