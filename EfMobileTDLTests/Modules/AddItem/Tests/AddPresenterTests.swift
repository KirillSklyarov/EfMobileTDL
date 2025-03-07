//
//  PresenterTests.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import XCTest
@testable import EfMobileTDL

final class AddItemInteractorSpy: AddItemInteractorInput {
    var addItemCalled = false
    var lastAddedItem: TDLItem?

    func addItem(_ item: TDLItem) {
        addItemCalled = true
        lastAddedItem = item
    }
}

final class AddItemPresenterTests: XCTestCase {
    var presenter: AddItemPresenter!
    var mockView: AddItemViewSpy!
    var mockInteractor: AddItemInteractorSpy!
    var mockRouter: RouterSpy!
    
    override func setUp() {
        super.setUp()
        mockView = AddItemViewSpy()
        mockInteractor = AddItemInteractorSpy()
        mockRouter = RouterSpy()
        presenter = AddItemPresenter(interactor: mockInteractor, router: mockRouter)

        presenter.view = mockView
    }
    
    override func tearDown() {
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        presenter = nil
        super.tearDown()
    }
    
    func testViewLoaded() {
        presenter.viewLoaded()
        XCTAssertTrue(mockView.setupInitialStateCalled)
    }
    
    func testCheckButtonBothFieldsEmpty() {
        presenter.addedItemTitle("")
        presenter.addedItemSubtitle("")
        
        XCTAssertTrue(mockView.isSaveButtonEnableCalled, "isSaveButtonEnable should be called")
        XCTAssertFalse(mockView.lastSaveButtonState ?? true, "Button should be disabled when both fields are empty")
    }
    
    func testCheckButtonBothFieldsValid() {
        presenter.addedItemTitle("Test")
        presenter.addedItemSubtitle("Test")
        
        // Then
        XCTAssertTrue(mockView.isSaveButtonEnableCalled)
        XCTAssertTrue(mockView.lastSaveButtonState ?? false)
    }
    
    func testSendButtonTapped() {
        presenter.addedItemTitle("Test")
        presenter.addedItemSubtitle("Test")
        
        // When
        presenter.sendButtonTapped()
        
        // Then
        XCTAssertTrue(mockInteractor.addItemCalled, "addItem should be called")
        XCTAssertNotNil(mockInteractor.lastAddedItem, "An item should be added")
        XCTAssertEqual(mockInteractor.lastAddedItem?.title, "Test", "Item should have correct title")
        XCTAssertEqual(mockInteractor.lastAddedItem?.subtitle, "Test", "Item should have correct subtitle")
        XCTAssertFalse(mockInteractor.lastAddedItem?.completed ?? true, "Item should not be completed")
        XCTAssertTrue(mockRouter.popCalled, "Router's pop method should be called")
    }
}
