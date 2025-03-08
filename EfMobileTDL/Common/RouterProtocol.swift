//
//  RouterProtocol.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 08.03.2025.
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
