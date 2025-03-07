//
//  ViewTests.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import XCTest
@testable import EfMobileTDL

final class AddItemViewTests: XCTestCase {
    
    var viewController: AddItemViewController!
    var mockPresenter: AddItemPresenterSpy!
    
    override func setUp() {
        super.setUp()
        mockPresenter = AddItemPresenterSpy()
        viewController = AddItemViewController(output: mockPresenter)
        
        // Load view
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // When
        viewController.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockPresenter.viewLoadedCalled, "viewLoaded should be called when view is loaded")
    }
    
    func testSetupInitialState() {
        // When
        viewController.setupInitialState()
        
        // Then
        XCTAssertNotNil(viewController.view.backgroundColor, "Background color should be set")
        XCTAssertEqual(viewController.title, "Добавить задачу", "Title should be set correctly")
    }
    
    func testIsSaveButtonEnable() {
        // When - enable button
        viewController.isSaveButtonEnable(true)
        
        // Get the save button (this requires accessing private property)
        let mirror = Mirror(reflecting: viewController)
        let saveButton = mirror.children.first { $0.label == "saveButton" }?.value as? AppButton
        
        // Then
        XCTAssertNotNil(saveButton, "Save button should exist")
        XCTAssertTrue(saveButton?.isEnabled ?? false, "Save button should be enabled")
        
        // When - disable button
        viewController.isSaveButtonEnable(false)
        
        // Then
        XCTAssertFalse(saveButton?.isEnabled ?? true, "Save button should be disabled")
    }
    
    func testTitleTextFieldDidChange() {
        // Create a textfield
        let textField = UITextField()
        textField.text = "Test Title"
        
        // When
        viewController.textFieldDidChange(textField)
        
        // Then
        XCTAssertTrue(mockPresenter.addedItemTitleCalled, "addedItemTitle should be called")
        XCTAssertEqual(mockPresenter.lastTitle, "Test Title", "The correct title should be passed to presenter")
    }
    
    func testTextViewDidChange() {
        // Create a text view
        let textView = UITextView()
        textView.text = "Test Subtitle"
        
        // When
        viewController.textViewDidChange(textView)
        
        // Then
        XCTAssertTrue(mockPresenter.addedItemSubtitleCalled, "addedItemSubtitle should be called")
        XCTAssertEqual(mockPresenter.lastSubtitle, "Test Subtitle", "The correct subtitle should be passed to presenter")
    }
    
    func testSaveButtonAction() {
        // Get the save button (this requires accessing private property)
        let mirror = Mirror(reflecting: viewController)
        let saveButton = mirror.children.first { $0.label == "saveButton" }?.value as? AppButton
        
        // When
        saveButton?.onButtonTapped?()
        
        // Then
        XCTAssertTrue(mockPresenter.sendButtonTappedCalled, "sendButtonTapped should be called when save button is tapped")
    }
}