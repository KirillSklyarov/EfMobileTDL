//
//  PresenterTests.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import XCTest
@testable import EfMobileTDL

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
        // When
        presenter.viewLoaded()
        
        // Then
        XCTAssertTrue(mockView.setupInitialStateCalled, "setupInitialState should be called")
        XCTAssertTrue(mockView.isSaveButtonEnableCalled, "isSaveButtonEnable should be called")
        XCTAssertFalse(mockView.lastSaveButtonState ?? true, "Save button should be disabled initially")
    }
    
    func testAddedItemTitle() {
        // When
        presenter.addedItemTitle("Test Title")
        
        // Then
        XCTAssertTrue(mockView.isSaveButtonEnableCalled, "isSaveButtonEnable should be called")
        XCTAssertFalse(mockView.lastSaveButtonState ?? true, "Button should still be disabled when only title is provided")
    }
    
    func testAddedItemSubtitle() {
        // When
        presenter.addedItemSubtitle("Test Subtitle")
        
        // Then
        XCTAssertTrue(mockView.isSaveButtonEnableCalled, "isSaveButtonEnable should be called")
        XCTAssertFalse(mockView.lastSaveButtonState ?? true, "Button should still be disabled when only subtitle is provided")
    }
    
    func testCheckButtonBothFieldsEmpty() {
        // When
        presenter.addedItemTitle("")
        presenter.addedItemSubtitle("")
        
        // Then
        XCTAssertTrue(mockView.isSaveButtonEnableCalled, "isSaveButtonEnable should be called")
        XCTAssertFalse(mockView.lastSaveButtonState ?? true, "Button should be disabled when both fields are empty")
    }
    
    func testCheckButtonBothFieldsValid() {
        // When
        presenter.addedItemTitle("Test Title")
        presenter.addedItemSubtitle("Test Subtitle")
        
        // Then
        XCTAssertTrue(mockView.isSaveButtonEnableCalled, "isSaveButtonEnable should be called")
        XCTAssertTrue(mockView.lastSaveButtonState ?? false, "Button should be enabled when both fields are valid")
    }
    
    func testSendButtonTapped() {
        // Given
        presenter.addedItemTitle("Test Title")
        presenter.addedItemSubtitle("Test Subtitle")
        
        // When
        presenter.sendButtonTapped()
        
        // Then
        XCTAssertTrue(mockInteractor.addItemCalled, "addItem should be called")
        XCTAssertNotNil(mockInteractor.lastAddedItem, "An item should be added")
        XCTAssertEqual(mockInteractor.lastAddedItem?.title, "Test Title", "Item should have correct title")
        XCTAssertEqual(mockInteractor.lastAddedItem?.subtitle, "Test Subtitle", "Item should have correct subtitle")
        XCTAssertFalse(mockInteractor.lastAddedItem?.completed ?? true, "Item should not be completed")
        XCTAssertTrue(mockRouter.popCalled, "Router's pop method should be called")
    }
    
    func testSendButtonTappedWithEmptyFields() {
        // Given
        presenter.addedItemTitle("")
        presenter.addedItemSubtitle("")
        
        // When
        presenter.sendButtonTapped()
        
        // Then
        XCTAssertFalse(mockInteractor.addItemCalled, "addItem should not be called with empty fields")
        XCTAssertNil(mockInteractor.lastAddedItem, "No item should be added")
        XCTAssertTrue(mockRouter.popCalled, "Router's pop method should still be called")
    }
}