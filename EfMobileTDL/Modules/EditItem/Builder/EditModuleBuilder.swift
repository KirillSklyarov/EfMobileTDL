//
//  EditModuleBuilder.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation

final class EditModuleBuilder {
    // MARK: - Properties
    private let dataManager: CoreDataManagerProtocol

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol) {
        self.dataManager = dataManager
    }

    // MARK: - Methods
    func build() -> EditItemViewController {
        let interactor = EditTaskInteractor(dataManager: dataManager)
        let presenter = EditPresenter(interactor: interactor)
        let view = EditItemViewController(output: presenter)

        interactor.presenter = presenter
        presenter.view = view

        return view
    }
}
