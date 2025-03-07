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
        
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        viewController.viewDidLoad()
        XCTAssertTrue(mockPresenter.viewLoadedCalled)
    }
    
    func testSetupInitialState() {
        viewController.setupInitialState()
        XCTAssertNotNil(viewController.view.backgroundColor, "Background color should be set")
        XCTAssertEqual(viewController.title, "Добавить задачу", "Title should be set correctly")
    }
    
    func testTitleTextFieldDidChange() {
        let textField = UITextField()
        textField.text = "Test Title"
        viewController.textFieldDidChange(textField)
        
        XCTAssertTrue(mockPresenter.addedItemTitleCalled)
        XCTAssertEqual(mockPresenter.lastTitle, "Test Title")
    }
    
    func testTextViewDidChange() {
        let textView = UITextView()
        textView.text = "Test Subtitle"
        
        viewController.textViewDidChange(textView)
        
        XCTAssertTrue(mockPresenter.addedItemSubtitleCalled)
        XCTAssertEqual(mockPresenter.lastSubtitle, "Test Subtitle")
    }
}
