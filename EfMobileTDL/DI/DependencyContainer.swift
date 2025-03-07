//
//  DI.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import UIKit

final class DependencyContainer {

    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let session: URLSession
    let networkClient: NetworkClient
    let networkService: NetworkService
    let coreDataManager: CoreDataManager
    let moduleFactory: ModuleFactory
    let navigationController: UINavigationController
    let routerFactory: RouterFactoryProtocol

    init() {
        decoder = JSONDecoder()
        encoder = JSONEncoder()
        session = URLSession(configuration: .default)
        navigationController = UINavigationController()

        networkClient = NetworkClient(decoder: decoder, encoder: encoder, session: session)
        networkService = NetworkService(networkClient: networkClient)

        coreDataManager = CoreDataManager()

        routerFactory = RouterFactory(navigationController: navigationController)

        moduleFactory = ModuleFactory(dataManager: coreDataManager, routerFactory: routerFactory, networkService: networkService)

        routerFactory.setModuleFactory(moduleFactory)
    }

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter
    }()
}
