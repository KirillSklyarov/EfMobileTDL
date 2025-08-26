//
//  EditPresenter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import Foundation

protocol EditItemViewOutput: ViewOutputProtocol, TextInputProtocol {
    func viewLoaded()
    func eventHandler(_ event: EditItemEvent)
}

enum EditItemPresenterState {
    case idle
    case loading
    case dataValidating(data: TDLItem?)
    case success(data: TDLItem)
    case error(_ type: AlertType)
}

enum EditItemEvent {
    case saveButtonTapped
}


final class EditPresenter {

    // MARK: - Properties
    var interactor: EditItemInteractorInput
    weak var view: EditItemViewInput?
    private let router: RouterProtocol

    var itemToEdit: TDLItem?

    // MARK: - Init
    init(interactor: EditItemInteractorInput, router: RouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - EditTaskViewOutput
extension EditPresenter: EditItemViewOutput {
    func viewLoaded() {
        setState(.idle)
    }

    func eventHandler(_ event: EditItemEvent) {
        switch event {
        case .saveButtonTapped:
            if changedTaskValidation() {
                guard let itemToEdit else { return }
                interactor.updateItem(itemToEdit)
                router.pop()
            } else {
                setState(.error(.editTaskError))
            }
        }
    }
}

// MARK: - TextInputProtocol
extension EditPresenter {
    func handleTitleChange(title: String) {
        itemToEdit?.title = title
    }

    func handleSubTitleChange(subTitle: String) {
        itemToEdit?.subtitle = subTitle
    }
}

// MARK: - Supporting methods
private extension EditPresenter {
    func setState(_ state: EditItemPresenterState) {
        switch state {
        case .idle:
            view?.setupInitialState()
            loadData()
        case .loading:
            view?.showLoading()
            getDataFromInteractor()
        case .dataValidating(let data):
            dataValidating(data)
        case .success(let data):
            self.itemToEdit = data
            DispatchQueue.main.async { [weak self] in
                self?.view?.configure(with: data)
            }
        case .error(let type):
            DispatchQueue.main.async { [weak self] in
                let alert = AppAlert.create(type)
                self?.view?.showError(alert)
            }
        }
    }

    func loadData() {
        setState(.loading)
    }

    func dataValidating(_ data: TDLItem?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            isDataValid(data) ? setState(.success(data: data!)) : setState(.error(.loadingError))
        }
    }

    func isDataValid(_ data: TDLItem?) -> Bool {
        return data != nil
    }

    func getDataFromInteractor() {
        let itemToEdit = interactor.getTaskToEdit()
        setState(.dataValidating(data: itemToEdit))
    }

    func changedTaskValidation() -> Bool {
        guard let itemToEdit else { return false }
        let title = itemToEdit.title
        let subtitle = itemToEdit.subtitle
        return !title.isBlank && !subtitle.isBlank
    }
}
