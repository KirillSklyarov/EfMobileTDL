//
//  MainBuilder.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//


import Foundation

final class MainModuleBuilder {
    // MARK: - Properties
    private let dataManager: CoreDataManagerProtocol
    private let routerFactory: RouterFactoryProtocol
    private let networkService: NetworkServiceProtocol

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol, routerFactory: RouterFactoryProtocol, networkService: NetworkServiceProtocol) {
        self.dataManager = dataManager
        self.routerFactory = routerFactory
        self.networkService = networkService
    }

    // MARK: - Methods
    func build() -> MainViewController {
        let router = routerFactory.makeMainRouter()
        let interactor = MainInteractor(dataManager: dataManager, networkService: networkService)
        let presenter = MainPresenter(interactor: interactor, router: router)
        let view = MainViewController(output: presenter)

        interactor.output = presenter
        presenter.view = view

        return view
    }
}
