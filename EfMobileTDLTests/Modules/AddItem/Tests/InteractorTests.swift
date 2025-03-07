//
//  InteractorTests.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import XCTest
@testable import EfMobileTDL

final class AddItemInteractorTests: XCTestCase {
    
    var interactor: AddItemInteractor!
    var mockDataManager: MockCoreDataManager!
    var mockPresenter: AddItemPresenterSpy!
    
    override func setUp() {
        super.setUp()
        mockDataManager = MockCoreDataManager()
        mockPresenter = AddItemPresenterSpy()
        interactor = AddItemInteractor(dataManager: mockDataManager)
        interactor.presenter = mockPresenter
    }
    
    override func tearDown() {
        interactor = nil
        mockDataManager = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testAddItem() {
        let testItem = TDLItem(id: 123, title: "Test", subtitle: "Test", date: "07/03/25", completed: false)
        interactor.addItem(testItem)
        
        // Then
        XCTAssertTrue(mockDataManager.addNewItemCalled)
        XCTAssertEqual(mockDataManager.lastAddedItem?.id, testItem.id)
        XCTAssertEqual(mockDataManager.lastAddedItem?.title, testItem.title)
        XCTAssertEqual(mockDataManager.lastAddedItem?.subtitle, testItem.subtitle)
    }
}
