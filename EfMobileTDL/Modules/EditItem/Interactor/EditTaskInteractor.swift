//
//  EditTaskInteractor.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation

protocol EditTaskInteractorInput {
    func setTaskToEdit()
    func getTaskToEdit() -> TDLItem?
    func updateTask(_ task: TDLItem)
}

final class EditTaskInteractor {

    // MARK: - Properties
    private let dataManager: CoreDataManagerProtocol
    weak var presenter: EditPresenter?

    private var taskToEdit: TDLItem?

    // MARK: - Init
    init(dataManager: CoreDataManagerProtocol) {
        self.dataManager = dataManager
        setTaskToEdit()
    }
}

extension EditTaskInteractor: EditTaskInteractorInput {
    func setTaskToEdit() {
        taskToEdit = dataManager.getItemToEdit()
    }

    func getTaskToEdit() -> TDLItem? {
        taskToEdit
    }

    func updateTask(_ item: TDLItem) {
        dataManager.updateItem(item)
    }
}
