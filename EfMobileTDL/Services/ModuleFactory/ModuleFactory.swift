//
//  ModuleFactory.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import UIKit

protocol ModuleFactoryProtocol {
    func makeModule(_ module: AppModule) -> UIViewController
}

// Enum который указывает список экранов
enum AppModule {
    case editItem
    case addItem
}

// Класс фабрика экранов отвечает за создание экранов
final class ModuleFactory {
    // MARK: - Properties
    private let dataManager: CoreDataManagerProtocol
    private let routerFactory: RouterFactoryProtocol

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol, routerFactory: RouterFactoryProtocol) {
        self.dataManager = dataManager
        self.routerFactory = routerFactory
    }
}

// MARK: - ProfileScreenFactoryProtocol
extension ModuleFactory: ModuleFactoryProtocol {
    func makeModule(_ module: AppModule) -> UIViewController {
        switch module {
        case .editItem: makeEditItemModule()
        case .addItem: makeAddItemModule()
        }
    }
}

// MARK: - Supporting methods
private extension ModuleFactory {
    func makeEditItemModule() -> EditItemViewController {
        let builder = EditModuleBuilder(dataManager: dataManager)
        return builder.build()
    }

    func makeAddItemModule() -> AddItemViewController {
        let builder = AddItemModuleBuilder(dataManager: dataManager, routerFactory: routerFactory)
        return builder.build()
    }
}
