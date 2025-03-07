//
//  RouterFactory.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//


import UIKit

protocol RouterFactoryProtocol: AnyObject {
    func makeRouter(_ module: AppModule) -> RouterProtocol
    func makeMainRouter() -> MainRouterProtocol
    func setModuleFactory(_ moduleFactory: ModuleFactoryProtocol?)
}

// Класс фабрика экранов отвечает за создание экранов
final class RouterFactory: RouterFactoryProtocol {

    // MARK: - Properties
    private let navigationController: UINavigationController
    weak var moduleFactory: ModuleFactoryProtocol?

    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func setModuleFactory(_ moduleFactory: ModuleFactoryProtocol?) {
        self.moduleFactory = moduleFactory
    }
}

// MARK: - ProfileScreenFactoryProtocol
extension RouterFactory {
    func makeRouter(_ module: AppModule) -> RouterProtocol {
        switch module {
        case .main: makeMainRouter()
        case .editItem: makeEditItemRouter()
        case .addItem: makeAddItemModule()
        }
    }

    func makeMainRouter() -> MainRouterProtocol {
        return MainRouter(moduleFactory: moduleFactory!, navigationController: navigationController)
    }
}

// MARK: - Supporting methods
private extension RouterFactory {
    func makeEditItemRouter() -> EditItemRouter {
        return EditItemRouter(navigationController: navigationController)
    }

    func makeAddItemModule() -> AddItemRouter {
        return AddItemRouter(navigationController: navigationController)
    }
}
