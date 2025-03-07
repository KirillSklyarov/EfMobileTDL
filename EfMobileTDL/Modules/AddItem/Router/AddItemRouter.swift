//
//  AddItemRouter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import UIKit

protocol AddItemRouterProtocol: RouterProtocol {

}

final class AddItemRouter: AddItemRouterProtocol {
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
