//
//  EditPresenter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation

protocol EditTaskViewOutput: AnyObject {
    func viewLoaded()
    func loadData()
    func checkDataAndUpdateView()
    func isDataValid() -> Bool
    func updateView()
    func setErrorState()
    func viewWillDisappear()
    func didUpdateTaskTitle(_ title: String)
    func didUpdateTaskSubTitle(_ subtitle: String)
}

final class EditPresenter {

    // MARK: - Properties
    private let interactor: EditTaskInteractorInput
    weak var view: EditTaskViewInput?

    private var taskToEdit: TDLItem?

    // MARK: - Init
    init(interactor: EditTaskInteractorInput) {
        self.interactor = interactor
    }
}

// MARK: - EditTaskViewOutput
extension EditPresenter: EditTaskViewOutput {
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
        checkDataAndUpdateView()
    }

    func loadData() {
        view?.showLoading()
        getDataFromInteractor()
    }

    // Если какие-то данные не получили, то показывает алерт с ошибкой, если все ок, то выставляем статус success
    func checkDataAndUpdateView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            isDataValid() ? updateView() : setErrorState()
        }
    }

    // Проверяем на nil все данные, если где-то будет nil, то это ошибка
    func isDataValid() -> Bool {
        let data: [Any?] = [taskToEdit]
        return data.allSatisfy { $0 != nil }
    }

    // Прокидываем данные на view и формируем ее
    func updateView() {
        guard let taskToEdit else { return }
        view?.configure(with: taskToEdit)
    }

    func setErrorState() {
        view?.showError()
    }

    func didUpdateTaskTitle(_ title: String) {
        if !title.isEmpty && title != taskToEdit?.title {
            taskToEdit?.title = title
        }
    }

    func didUpdateTaskSubTitle(_ subtitle: String) {
        if !subtitle.isEmpty && subtitle != taskToEdit?.subtitle {
            taskToEdit?.subtitle = subtitle
        }
    }

    func viewWillDisappear() {
        guard let taskToEdit else { return }
        interactor.updateTask(taskToEdit)
    }
}

// MARK: - Supporting methods
private extension EditPresenter {
    func getDataFromInteractor() {
        taskToEdit = interactor.getTaskToEdit()
    }
}
