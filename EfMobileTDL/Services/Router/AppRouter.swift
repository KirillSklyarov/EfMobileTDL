//
//  Router.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import UIKit

final class AppRouter {

    // MARK: - Properties
    private(set) var navigationController: UINavigationController?

    func setupRootViewController(with vc: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: vc)
        self.navigationController = navigationController
        return navigationController
    }
}

// MARK: - Push&Pop
extension AppRouter {
    func push(to view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
    }

    func pop() {
        navigationController?.popViewController(animated: true)
    }
}
