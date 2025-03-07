//
//  MainRouter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import UIKit

protocol MainRouterProtocol: RouterProtocol {
    func goToEditItemModule()
    func goToAddItemModule()
}

final class MainRouter: MainRouterProtocol {

    // MARK: - Properties
    private let moduleFactory: ModuleFactoryProtocol
    var navigationController: UINavigationController?

    init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.moduleFactory = moduleFactory
        self.navigationController = navigationController
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
