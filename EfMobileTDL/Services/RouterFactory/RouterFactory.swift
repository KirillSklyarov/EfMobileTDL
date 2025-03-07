//
//  RouterFactory.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import UIKit

protocol RouterProtocol: AnyObject {
    var navigationController: UINavigationController? { get }

    func push(to view: UIViewController)
    func pop()
}

extension RouterProtocol {
    func pop() {
        guard let navigationController = navigationController else { print("Navigation controller is nil, so can not pop"); return }
        navigationController.popViewController(animated: true)
    }

    func push(to view: UIViewController) {
        guard let navigationController = navigationController else { print("Navigation controller is nil, so can not push"); return }
        navigationController.pushViewController(view, animated: true)
    }
}


protocol RouterFactoryProtocol: AnyObject {
    func makeMainRouter() -> MainRouterProtocol
    func makeEditItemRouter() -> EditItemRouter
    func makeAddItemModule() -> AddItemRouter

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
    func makeMainRouter() -> MainRouterProtocol {
        return MainRouter(moduleFactory: moduleFactory!, navigationController: navigationController)
    }

    func makeEditItemRouter() -> EditItemRouter {
        return EditItemRouter(navigationController: navigationController)
    }

    func makeAddItemModule() -> AddItemRouter {
        return AddItemRouter(navigationController: navigationController)
    }
}
