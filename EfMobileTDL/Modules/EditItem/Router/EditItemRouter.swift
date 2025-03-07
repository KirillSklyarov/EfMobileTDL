//
//  EditItemRouter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import UIKit

protocol EditItemRouterProtocol: RouterProtocol {

}

final class EditItemRouter: EditItemRouterProtocol {
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
