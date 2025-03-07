//
//  DI.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import UIKit

final class DependencyContainer {

    let interactor: Interactor
    let startManager: AppStartManager
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let session: URLSession
    let networkClient: NetworkClient
    let networkService: NetworkService
    let router: AppRouterProtocol
    let coreDataManager: CoreDataManager
    let moduleFactory: ModuleFactory
    let navigationController: UINavigationController
    let routerFactory: RouterFactoryProtocol

    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        session = URLSession(configuration: .default)
        navigationController = UINavigationController()

        interactor = Interactor()

        networkClient = NetworkClient(decoder: decoder, encoder: encoder, session: session)
        networkService = NetworkService(networkClient: networkClient)

        coreDataManager = CoreDataManager()

        routerFactory = RouterFactory(dataManager: coreDataManager, navigationController: navigationController)

        moduleFactory = ModuleFactory(dataManager: coreDataManager, routerFactory: routerFactory)

        router = AppRouter(moduleFactory: moduleFactory, navigationController: navigationController)

        startManager = AppStartManager(interactor: interactor, networkService: networkService, router: router, coreDataManager: coreDataManager)
    }
}
