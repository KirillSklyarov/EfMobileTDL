//
//  MainRouter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import UIKit

protocol MainRouterProtocol: RouterProtocol {
    func goToEditVC()
}

final class MainRouter: MainRouterProtocol {

    // MARK: - Properties
    private let moduleFactory: ModuleFactoryProtocol
    var navigationController: UINavigationController?

    init(moduleFactory: ModuleFactoryProtocol, navigationController: UINavigationController) {
        self.moduleFactory = moduleFactory
        self.navigationController = navigationController
    }

    func goToEditVC() {
        let editVC = moduleFactory.makeModule(.editItem)
        push(to: editVC)
    }
}
