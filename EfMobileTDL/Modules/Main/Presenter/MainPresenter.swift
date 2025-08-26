//
//  MainPresenter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol MainViewOutput: AnyObject {
    func viewLoaded()
    func appearingUpdateUI()

    func eventHandler(_ event: MainEvent)
    func setState(_ state: PresenterState)
}

enum MainEvent {
    case addNewTask
    case editTask(TDLItem)
    case deleteItem(TDLItem)
    case changeItemState(TDLItem)
    case filterData(by: String)
    case cancelSearch
}

enum PresenterState {
    case idle
    case loading
    case dataValidating(data: [TDLItem])
    case success(data: [TDLItem])
    case error
}

final class MainPresenter {

    private let interactor: MainInteractorInput
    private let router: MainRouterProtocol
    weak var view: MainViewInput?

    private var data: [TDLItem]?

    private var isFirstLoad = true

    init(interactor: MainInteractorInput, router: MainRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - MainViewOutput
extension MainPresenter: MainViewOutput {

    func viewLoaded() {
        setState(.idle)
    }

    func updateDataFromCD() {
        interactor.getNewDataFromCD()
    }

    func eventHandler(_ event: MainEvent) {
        switch event {
        case .addNewTask:
            view?.resetSearchController()
            router.goToAddItemModule()
        case .editTask(let item):
            view?.resetSearchController()
            interactor.selectItemForEditing(item)
            router.goToEditItemModule()
        case .deleteItem(let item):
            interactor.removeTask(item)
        case .changeItemState(let item):
            interactor.changeTaskState(item)
        case .filterData(let text):
            let filteredData = interactor.filterData(by: text)
            setState(.success(data: filteredData))
        case .cancelSearch:
            updateDataFromCD()
        }
    }

    func setState(_ state: PresenterState) {
        switch state {
        case .idle:
            view?.setupInitialState()
            loadData()
        case .loading:
            view?.loading()
        case .dataValidating(let data):
            dataValidating(data)
        case .success(let data):
            DispatchQueue.main.async { [weak self] in
                self?.view?.configure(with: data)
            }
        case .error:
            DispatchQueue.main.async { [weak self] in
                let alert = AppAlert.create(.loadingError)
                self?.view?.showError(alert)
            }
        }
    }

    func appearingUpdateUI() {
        if !isFirstLoad {
           updateDataFromCD()
        } else {
            isFirstLoad = false
        }
    }
}

// MARK: - Supporting methods
private extension MainPresenter {
    func loadData() {
        setState(.loading)
        Task { await interactor.fetchData() }
    }

    func dataValidating(_ data: [TDLItem]) {
        self.data = data
        isDataValid() ? dataLoadedSuccessful() : getError()
    }

    func isDataValid() -> Bool {
        let data: [Any?] = [data]
        return data.allSatisfy { $0 != nil }
    }

    func dataLoadedSuccessful() {
        guard let data else { return }
        setState(.success(data: data))
    }

    func getError() {
        setState(.error)
    }
}
