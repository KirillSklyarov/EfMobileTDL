//
//  MainPresenter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol MainViewOutput: AnyObject {
    func viewLoaded()
    func viewIsAppearing()
    func dataLoaded(_ data: [TDLItem])
    func checkDataAndUpdateView()
    func getError()
    func selectItemForEditing(_ item: TDLItem)
    func addNewTaskButtonTapped()
    func removeItemTapped(_ item: TDLItem)
    func changeItemState(_ item: TDLItem)
    func filterData(by: String)
}

final class MainPresenter {

    private let interactor: MainInteractorInput
    private let router: MainRouterProtocol
    weak var view: MainViewInput?

    private var data: [TDLItem]?

    init(interactor: MainInteractorInput, router: MainRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - MainViewOutput
extension MainPresenter: MainViewOutput {
    func viewIsAppearing() {
        interactor.getNewDataFromCD()
        view?.updateUI(with: data ?? [])
    }
    
    func filterData(by text: String) {
        let filteredData = interactor.filterData(by: text)
        view?.updateUI(with: filteredData)
    }

    func changeItemState(_ item: TDLItem) {
        interactor.changeTaskState(item)
    }
    
    func removeItemTapped(_ item: TDLItem) {
        interactor.removeTask(item)
    }
    
    func addNewTaskButtonTapped() {
        router.goToAddItemModule()
    }
    
    func selectItemForEditing(_ item: TDLItem) {
        interactor.selectItemForEditing(item)
        router.goToEditItemModule()
    }
    
    func viewLoaded() {
        view?.setupInitialState()
        loadData()
    }

    func loadData() {
        view?.loading()
        Task { await interactor.fetchData() }
    }

    func dataLoaded(_ data: [TDLItem]) {
        print(#function)
        self.data = data
        checkDataAndUpdateView()
    }

    func checkDataAndUpdateView() {
        isDataValid() ? updateView() : getError()
    }

    // Проверяем на nil все данные, если где-то будет nil, то это ошибка
    func isDataValid() -> Bool {
        let data: [Any?] = [data]
        return data.allSatisfy { $0 != nil }
    }

    // Прокидываем данные на view и формируем ее
    func updateView() {
        print(#function)
        guard let data else { return }
        DispatchQueue.main.async { [weak self] in
            print(data)
            self?.view?.configure(with: data)
        }
    }

    func getError() {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError()
        }
    }
}
