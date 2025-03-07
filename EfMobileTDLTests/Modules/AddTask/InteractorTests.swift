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
        // Given
        let testItem = TDLItem(id: 123, title: "Test Title", subtitle: "Test Subtitle", date: "01/01/25", completed: false)
        
        // When
        interactor.addItem(testItem)
        
        // Then
        XCTAssertTrue(mockDataManager.addNewItemCalled, "DataManager's addNewItem should be called")
        XCTAssertEqual(mockDataManager.lastAddedItem?.id, testItem.id, "The correct item should be added")
        XCTAssertEqual(mockDataManager.lastAddedItem?.title, testItem.title, "The correct title should be set")
        XCTAssertEqual(mockDataManager.lastAddedItem?.subtitle, testItem.subtitle, "The correct subtitle should be set")
    }
}

// Mock for CoreDataManager
class MockCoreDataManager: CoreDataManagerProtocol {
    var addNewItemCalled = false
    var lastAddedItem: TDLItem?
    
    func addNewItem(_ item: TDLItem) {
        addNewItemCalled = true
        lastAddedItem = item
    }
    
    func deleteItem(_ id: Int) {
        // Not needed for these tests
    }
    
    func changeCompletedStatus(_ id: Int) {
        // Not needed for these tests
    }
    
    func getAllItems() -> [TDLItem] {
        // Not needed for these tests
        return []
    }
    
    func updateTitle(_ id: Int, newTitle: String) {
        // Not needed for these tests
    }
    
    func updateSubTitle(_ id: Int, newSubTitle: String) {
        // Not needed for these tests
    }
    
    func updateItem(_ item: TDLItem) {
        // Not needed for these tests
    }
    
    func getItem(by id: Int) -> TDLItem? {
        // Not needed for these tests
        return nil
    }
}