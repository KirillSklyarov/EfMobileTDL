//
//  Router.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
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

protocol AppRouterProtocol: RouterProtocol {
    func setupRootViewController(with vc: UIViewController) -> UINavigationController?
    func goToEditItemModule()
    func goToAddItemModule()
}

final class AppRouter: AppRouterProtocol {

    // MARK: - Properties
    private let moduleFactory: ModuleFactoryProtocol
    var navigationController: UINavigationController?

    init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.moduleFactory = moduleFactory
        self.navigationController = navigationController
    }

    func setupRootViewController(with vc: UIViewController) -> UINavigationController? {
        guard let navigationController = navigationController else {
            print("Navigation controller not set"); return nil
        }
        navigationController.viewControllers = [vc]
        return navigationController
    }

    func goToEditItemModule() {
        let editVC = moduleFactory.makeModule(.editItem)
        push(to: editVC)
    }

    func goToAddItemModule() {
        let addItemVC = moduleFactory.makeModule(.addItem)
        push(to: addItemVC)
    }
}
