//
//  AppStartManager.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import UIKit

final class AppStartManager {

    private let interactor: Interactor
    private let networkService: NetworkService
    private let router: AppRouterProtocol
    private let coreDataManager: CoreDataManager
    private let moduleFactory: ModuleFactoryProtocol

    private var window: UIWindow?
    private var mainViewController: UIViewController?
    private var rootNavigationController: UINavigationController?

    private let userDefaults = UserDefaults.standard
    private var data: [TDLItem] = []

    // MARK: - Init
    init(interactor: Interactor, networkService: NetworkService, router: AppRouterProtocol, coreDataManager: CoreDataManager, moduleFactory: ModuleFactoryProtocol) {
        self.interactor = interactor
        self.networkService = networkService
        self.router = router
        self.coreDataManager = coreDataManager
        self.moduleFactory = moduleFactory
    }


    // MARK: - Public methods
    func startApp() {
        showRootVC()
//        mainViewController?.loading()

//        Task { await fetchData() }
    }

    // Принимаем окно из SceneDelegate
    func setWindow(_ window: UIWindow?) {
        self.window = window
    }
}

// MARK: - Fetch Data
private extension AppStartManager {
//    func fetchData() async {
//        let isFirstLaunch = !userDefaults.bool(forKey: "hasLaunchedBefore")
//
//        do {
//            try await fetchDataIsFirstLaunch(isFirstLaunch)
//            await updateVC()
//        } catch {
//            await setVCErrorState()
//            print(error)
//        }
//    }
//
//    func updateVC() async {
//        await MainActor.run {
//            mainViewController?.configure(with: data)
//        }
//    }

//    func setVCErrorState() async {
//        await MainActor.run {
//            mainViewController?.error()
//        }
//    }

//    func fetchDataIsFirstLaunch(_ isFirstLaunch: Bool) async throws {
//        if isFirstLaunch {
//            data = try await networkService.fetchDataFromServer()
//            print("🌐 Data fetched from server")
//            userDefaults.set(true, forKey: "hasLaunchedBefore")
//            coreDataManager.saveDataInCoreData(tdlItems: data)
//        } else {
////            data = coreDataManager.getCorrectDataFromCoreData()
//            print("📦 Data fetched from CoreData")
//        }
//
//        interactor.setUserTasks(data)
//    }
}

private extension AppStartManager {
    func showRootVC() {
        mainViewController = moduleFactory.makeModule(.main)

//        let interactor = MainInteractor(dataManager: coreDataManager, networkService: networkService)
//        let presenter = MainPresenter(interactor: interactor, router: router)
//        mainViewController = MainViewController(interactor: interactor, output: presenter)
//        interactor.output = presenter
//        presenter.view = mainViewController
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
