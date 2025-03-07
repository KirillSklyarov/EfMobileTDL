import XCTest
@testable import EfMobileTDL

final class MainPresenterTests: XCTestCase {
    // MARK: - Properties
    
    private var presenter: MainPresenter!
    private var interactorSpy: MainInteractorSpy!
    private var viewSpy: MainViewSpy!
    private var routerSpy: MainRouterSpy!
    
    private let mockItems: [TDLItem] = [
        TDLItem(id: 1, title: "Task 1", subtitle: "Subtitle 1", date: Date().description, completed: false),
        TDLItem(id: 2, title: "Task 2", subtitle: "Subtitle 2", date: Date().description, completed: true)
    ]

    // MARK: - Test Lifecycle
    
    override func setUp() {
        super.setUp()
        interactorSpy = MainInteractorSpy()
        viewSpy = MainViewSpy()
        routerSpy = MainRouterSpy()
        presenter = MainPresenter(interactor: interactorSpy, router: routerSpy)
        presenter.view = viewSpy
    }
    
    override func tearDown() {
        presenter = nil
        interactorSpy = nil
        viewSpy = nil
        routerSpy = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testViewLoaded() {
        // Act
        presenter.viewLoaded()
        
        // Assert
        XCTAssertTrue(viewSpy.setupInitialStateCalled, "View's setupInitialState should be called")
        XCTAssertTrue(viewSpy.loadingCalled, "View's loading should be called")
    }
    
    func testViewIsAppearing() {
        // Act
        presenter.viewIsAppearing()
        
        // Assert
        XCTAssertTrue(interactorSpy.getNewDataFromCDCalled, "Interactor's getNewDataFromCD should be called")
        XCTAssertTrue(viewSpy.updateUICalled, "View's updateUI should be called")
    }
    
//    func testDataLoaded() {
//        // Act
//        presenter.dataLoaded(mockItems)
//        
//        // Assert
//        XCTAssertTrue(presenter.checkDataAndUpdateViewCalled, "Presenter's checkDataAndUpdateView should be called")
//    }
    
    func testCheckDataAndUpdateView() {
        // Arrange
        presenter.dataLoaded(mockItems)
        
        // Act
        presenter.checkDataAndUpdateView()
        
        // Assert
        // Since this method uses a delay, we need to use expectations
        let expectation = XCTestExpectation(description: "Wait for delayed execution")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewSpy.configureCalled, "View's configure should be called with data")
        XCTAssertEqual(viewSpy.lastDataReceived?.count, mockItems.count, "View should receive correct data")
    }
    
    func testGetError() {
        // Act
        presenter.getError()
        
        // Assert
        XCTAssertTrue(viewSpy.showErrorCalled, "View's showError should be called")
    }
    
    func testSelectItemForEditing() {
        // Act
        presenter.selectItemForEditing(mockItems[0])
        
        // Assert
        XCTAssertTrue(interactorSpy.selectItemForEditingCalled, "Interactor's selectItemForEditing should be called")
        XCTAssertEqual(interactorSpy.lastItemForEditing?.id, mockItems[0].id, "Interactor should receive correct item")
        XCTAssertTrue(routerSpy.goToEditItemModuleCalled, "Router's goToEditItemModule should be called")
    }
    
    func testAddNewTaskButtonTapped() {
        // Act
        presenter.addNewTaskButtonTapped()
        
        // Assert
        XCTAssertTrue(routerSpy.goToAddItemModuleCalled, "Router's goToAddItemModule should be called")
    }
    
    func testRemoveItemTapped() {
        // Act
        presenter.removeItemTapped(mockItems[0])
        
        // Assert
        XCTAssertTrue(interactorSpy.removeTaskCalled, "Interactor's removeTask should be called")
        XCTAssertEqual(interactorSpy.lastTaskRemoved?.id, mockItems[0].id, "Interactor should receive correct item")
    }
    
    func testChangeItemState() {
        // Act
        presenter.changeItemState(mockItems[0])
        
        // Assert
        XCTAssertTrue(interactorSpy.changeTaskStateCalled, "Interactor's changeTaskState should be called")
        XCTAssertEqual(interactorSpy.lastTaskStateChanged?.id, mockItems[0].id, "Interactor should receive correct item")
    }
    
    func testFilterData() {
        // Arrange
        let searchQuery = "Task"
        interactorSpy.filteredDataToReturn = [mockItems[0]]
        
        // Act
        presenter.filterData(by: searchQuery)
        
        // Assert
        XCTAssertTrue(interactorSpy.filterDataCalled, "Interactor's filterData should be called")
        XCTAssertEqual(interactorSpy.lastFilterString, searchQuery, "Interactor should receive correct search query")
        XCTAssertTrue(viewSpy.updateUICalled, "View's updateUI should be called")
        XCTAssertEqual(viewSpy.lastDataReceived?.count, 1, "View should receive filtered items")
    }
}
