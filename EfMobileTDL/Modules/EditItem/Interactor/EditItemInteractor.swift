//
//  EditTaskInteractor.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation

protocol EditItemInteractorInput: InteractorInputProtocol {
    var itemToEdit: TDLItem? { get set }

    func setTaskToEdit()
    func getTaskToEdit() -> TDLItem?
    func updateItem(_ item: TDLItem)
}

final class EditItemInteractor {

    // MARK: - Properties
    private let dataManager: CoreDataManagerProtocol
    weak var output: ViewOutputProtocol?

    var itemToEdit: TDLItem?

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol) {
        self.dataManager = dataManager
        setTaskToEdit()
    }
}

// MARK: - EditItemInteractorInput
extension EditItemInteractor: EditItemInteractorInput {
    func setTaskToEdit() {
        itemToEdit = dataManager.getItemToEdit()
    }

    func getTaskToEdit() -> TDLItem? {
        itemToEdit
    }

    func updateItem(_ item: TDLItem) {
        dataManager.updateItem(item)
    }
}
