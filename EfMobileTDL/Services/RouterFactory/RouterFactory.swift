//
//  RouterFactory.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//


import UIKit

protocol RouterFactoryProtocol {
    func makeRouter(_ module: AppModule) -> RouterProtocol
}

// Класс фабрика экранов отвечает за создание экранов
final class RouterFactory {
    // MARK: - Properties
    private let navigationController: UINavigationController

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - ProfileScreenFactoryProtocol
extension RouterFactory: RouterFactoryProtocol {
    func makeRouter(_ module: AppModule) -> RouterProtocol {
        switch module {
        case .editItem: makeEditItemRouter()
        case .addItem: makeAddItemModule()
        }
    }
}

// MARK: - Supporting methods
private extension RouterFactory {
    func makeEditItemRouter() -> AddItemRouter {
        return AddItemRouter(navigationController: navigationController)

//        let builder = EditModuleBuilder(dataManager: dataManager)
//        return builder.build()
    }

    func makeAddItemModule() -> AddItemRouter {
        return AddItemRouter(navigationController: navigationController)
    }
}

