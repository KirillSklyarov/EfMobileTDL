//
//  RouterFactory.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import UIKit

protocol RouterFactoryProtocol: AnyObject {
    func makeMainRouter() -> MainRouterProtocol
    func makeEditItemRouter() -> EditItemRouter
    func makeAddItemRouter() -> AddItemRouter

    func setModuleFactory(_ moduleFactory: ModuleFactoryProtocol?)
}

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
    func makeMainRouter() -> MainRouterProtocol {
        return MainRouter(moduleFactory: moduleFactory!, navigationController: navigationController)
    }

    func makeEditItemRouter() -> EditItemRouter {
        return EditItemRouter(navigationController: navigationController)
    }

    func makeAddItemRouter() -> AddItemRouter {
        return AddItemRouter(navigationController: navigationController)
    }
}
