//
//  Router.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import UIKit

final class AppRouter {

    // MARK: - Properties
    private let navigationController: UINavigationController

    // MARK: - Init
    init() {
        self.navigationController = UINavigationController()
    }
}

// MARK: - Push&Pop
extension AppRouter {
    func push(to view: UIViewController) {
        navigationController.pushViewController(view, animated: true)
    }

    func pop() {
        navigationController.popViewController(animated: true)
    }
}
