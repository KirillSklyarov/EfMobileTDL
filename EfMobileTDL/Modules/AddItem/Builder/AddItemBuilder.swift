//
//  EditModuleBuilder.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation

final class AddItemModuleBuilder: BuilderProtocol {
    typealias Screen = AddItemViewController

    // MARK: - Properties
    private let dataManager: CoreDataManagerProtocol
    private let routerFactory: RouterFactoryProtocol

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol, routerFactory: RouterFactoryProtocol) {
        self.dataManager = dataManager
        self.routerFactory = routerFactory
    }

    // MARK: - Methods
    func build() -> AddItemViewController {
        let interactor = AddItemInteractor(dataManager: dataManager)
        let router = routerFactory.makeAddItemModule()
        let presenter = AddItemPresenter(interactor: interactor, router: router)
        let view = AddItemViewController(output: presenter)

        interactor.presenter = presenter
        presenter.view = view

        return view
    }
}
