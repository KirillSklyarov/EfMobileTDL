//
//  ModuleFactory.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import UIKit

protocol ModuleFactoryProtocol: AnyObject {
    func makeModule(_ module: AppModule) -> UIViewController
}

enum AppModule {
    case main
    case editItem
    case addItem
}

final class ModuleFactory {
    // MARK: - Properties
    private let dataManager: CoreDataManagerProtocol
    private let routerFactory: RouterFactoryProtocol
    private let networkService: NetworkService

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol, routerFactory: RouterFactoryProtocol, networkService: NetworkService) {
        self.dataManager = dataManager
        self.routerFactory = routerFactory
        self.networkService = networkService
    }
}

// MARK: - ProfileScreenFactoryProtocol
extension ModuleFactory: ModuleFactoryProtocol {
    func makeModule(_ module: AppModule) -> UIViewController {
        switch module {
        case .main: makeMainModule()
        case .editItem: makeEditItemModule()
        case .addItem: makeAddItemModule()
        }
    }
}

// MARK: - Supporting methods
private extension ModuleFactory {
    func makeMainModule() -> MainViewController {
        let builder = MainModuleBuilder(dataManager: dataManager, routerFactory: routerFactory, networkService: networkService)
        return builder.build()
    }

    func makeEditItemModule() -> EditItemViewController {
        let builder = EditModuleBuilder(dataManager: dataManager)
        return builder.build()
    }

    func makeAddItemModule() -> AddItemViewController {
        let builder = AddItemModuleBuilder(dataManager: dataManager, routerFactory: routerFactory)
        return builder.build()
    }
}
