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
    private let dataManager: CoreDataManager
    weak var presenter: EditPresenter?

    private var taskToEdit: TDLItem?

    // MARK: - Init
    init(dataManager: CoreDataManager) {
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

    func updateTask(_ task: TDLItem) {
        dataManager.updateTask(task)
    }
}
