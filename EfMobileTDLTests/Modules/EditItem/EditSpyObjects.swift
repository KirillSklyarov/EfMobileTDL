//
//  SpyObjects.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import UIKit
@testable import EfMobileTDL

// MARK: - Spy objects
final class EditModuleViewSpy: EditItemViewInput {

    // MARK: - Properties
    var setupInitialStateCalled = false
    var showLoadingCalled = false
    var showErrorCalled = false
    var configureCalled = false
    var titleChanged = false
    var data: TDLItem?

    // MARK: - Methods
    func setupInitialState() {
        setupInitialStateCalled = true
    }

    func showLoading() {
        showLoadingCalled = true
    }

    func configure(with task: TDLItem) {
        configureCalled = true
        data = task
    }

    func showError() {
        showErrorCalled = true
    }

    func textFieldDidChange(_ textField: UITextField) {
        titleChanged = true
    }

    func viewDidLoad() {

    }
}

final class EditItemInteractorSpy: EditItemInteractorInput {
    var itemToEdit: TDLItem?
    var updateItemCalled = false

    func setTaskToEdit() {
        0
    }

    func getTaskToEdit() -> TDLItem? {
        return itemToEdit
    }

    func updateItem(_ task: TDLItem) {
        updateItemCalled = true
    }

    var output: (any ViewOutputProtocol)?

}

final class EditItemPresenterSpy: EditItemViewOutput {
    // Свойства для отслеживания вызовов
    var viewLoadedCalled = false
    var checkDataAndUpdateViewCalled = false
    var updateViewCalled = false
    var setErrorStateCalled = false
    var viewWillDisappearCalled = false
    var didUpdateTaskTitleCalled = false
    var didUpdateTaskSubTitleCalled = false
    var lastUpdatedTitle: String?
    var lastUpdatedSubtitle: String?

    // Обязательные свойства из протокола
    var interactor: any EditItemInteractorInput
    var view: (any EditItemViewInput)?
    var itemToEdit: TDLItem?

    // Инициализатор с обязательным interactor
    init(interactor: any EditItemInteractorInput) {
        self.interactor = interactor
    }

    // Реализация методов с отслеживанием вызовов
    func viewLoaded() {
        viewLoadedCalled = true
    }

    func checkDataAndUpdateView() {
        checkDataAndUpdateViewCalled = true
    }

    func isDataValid() -> Bool {
        return itemToEdit != nil
    }

    func updateView() {
        updateViewCalled = true
    }

    func setErrorState() {
        setErrorStateCalled = true
    }

    func viewWillDisappear() {
        viewWillDisappearCalled = true
    }

    func didUpdateTaskTitle(_ title: String) {
        didUpdateTaskTitleCalled = true
        lastUpdatedTitle = title
    }

    func didUpdateTaskSubTitle(_ subtitle: String) {
        didUpdateTaskSubTitleCalled = true
        lastUpdatedSubtitle = subtitle
    }
}
