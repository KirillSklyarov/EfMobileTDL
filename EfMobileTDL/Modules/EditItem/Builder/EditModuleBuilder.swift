//
//  EditModuleBuilder.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation

final class EditModuleBuilder: BuilderProtocol {
    typealias Screen = EditItemViewController

    // MARK: - Properties
    private let dataManager: CoreDataManagerProtocol
    private let routerFactory: RouterFactoryProtocol
    private let navBarStyler: NavigationBarStyler

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol, navBarStyler: NavigationBarStyler, routerFactory: RouterFactoryProtocol) {
        self.dataManager = dataManager
        self.navBarStyler = navBarStyler
        self.routerFactory = routerFactory
    }

    // MARK: - Methods
    func build() -> EditItemViewController {
        let interactor = EditItemInteractor(dataManager: dataManager)
        let router = routerFactory.makeAddItemRouter()
        let presenter = EditPresenter(interactor: interactor, router: router)
        let view = EditItemViewController(output: presenter, navBarStyler: navBarStyler)

        interactor.output = presenter
        presenter.view = view

        return view
    }
}
