//
//  EditPresenter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation

protocol EditItemViewOutput: ViewOutputProtocol {
    var itemToEdit: TDLItem? { get set }

    func viewLoaded()
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
    var interactor: EditItemInteractorInput
    weak var view: EditItemViewInput?

    var itemToEdit: TDLItem?

    // MARK: - Init
    init(interactor: EditItemInteractorInput) {
        self.interactor = interactor
    }
}

// MARK: - EditTaskViewOutput
extension EditPresenter: EditItemViewOutput {
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
        let data: [Any?] = [itemToEdit]
        return data.allSatisfy { $0 != nil }
    }

    // Прокидываем данные на view и формируем ее
    func updateView() {
        guard let itemToEdit else { return }
        view?.configure(with: itemToEdit)
    }

    func setErrorState() {
        view?.showError()
    }

    func didUpdateTaskTitle(_ title: String) {
        if !title.isEmpty && title != itemToEdit?.title {
            itemToEdit?.title = title
        }
    }

    func didUpdateTaskSubTitle(_ subtitle: String) {
        if !subtitle.isEmpty && subtitle != itemToEdit?.subtitle {
            itemToEdit?.subtitle = subtitle
        }
    }

    func viewWillDisappear() {
        guard let itemToEdit else { return }
        interactor.updateItem(itemToEdit)
    }
}

// MARK: - Supporting methods
private extension EditPresenter {
    func getDataFromInteractor() {
        itemToEdit = interactor.getTaskToEdit()
    }
}
