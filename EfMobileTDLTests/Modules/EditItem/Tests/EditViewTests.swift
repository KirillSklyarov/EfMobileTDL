//
//  EditModule.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import XCTest
@testable import EfMobileTDL

final class ViewTests: XCTestCase {
    var mockView: EditModuleViewSpy!
    var dataManager: CoreDataManagerProtocol!
    var interactor: EditItemInteractorSpy!
    var presenter: EditItemViewOutput!

    override func setUp() {
        super.setUp()
        mockView = EditModuleViewSpy()
        dataManager = CoreDataManager()
        interactor = EditItemInteractorSpy()
        presenter = EditPresenter(interactor: interactor)

        interactor.output = presenter
        presenter.view = mockView
    }

    override func tearDown() {
        mockView = nil
        dataManager = nil
        interactor = nil
        presenter = nil
        super.tearDown()
    }

    func testSetupInitialStateAndShowLoading() {
        presenter.viewLoaded()
        XCTAssertTrue(mockView.setupInitialStateCalled)
        XCTAssertTrue(mockView.showLoadingCalled)
    }

    func testConfigureView() {
        let item = TDLItem(id: 444, title: "Test", subtitle: "Test", date: "23/03/2025", completed: false)
        interactor.itemToEdit = item

        presenter.viewLoaded()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        XCTAssertTrue(mockView.configureCalled)
        XCTAssertEqual(mockView.data?.title, "Test")
    }

    func testError() {
        interactor.itemToEdit = nil

        presenter.viewLoaded()

        let expectation = XCTestExpectation(description: "Wait for data loading")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation])

        XCTAssertTrue(mockView.showErrorCalled)
    }

    func testUpdateItemTitle() {
        presenter.itemToEdit = TDLItem(id: 444, title: "Test", subtitle: "Test", date: "23/03/2025", completed: false)

        presenter.viewWillDisappear()

        XCTAssertTrue(interactor.updateItemCalled)
    }
}
