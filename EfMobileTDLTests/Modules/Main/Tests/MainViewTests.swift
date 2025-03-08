import XCTest
@testable import EfMobileTDL

final class MainViewTests: XCTestCase {
    // MARK: - Properties
    
    private var viewController: MainViewController!
    private var presenterSpy: MainPresenterSpy!
    
    private let mockItems: [TDLItem] = [
        TDLItem(id: 1, title: "Task 1", subtitle: "Subtitle 1", date: Date().description, completed: false),
        TDLItem(id: 2, title: "Task 2", subtitle: "Subtitle 2", date: Date().description, completed: true)
    ]
    
    // MARK: - Test Lifecycle
    
    override func setUp() {
        super.setUp()
        presenterSpy = MainPresenterSpy()
        viewController = MainViewController(output: presenterSpy)
        
        // Load view
        _ = viewController.view
    }
    
    override func tearDown() {
        viewController = nil
        presenterSpy = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testViewDidLoad() {
        // Assert
        XCTAssertTrue(presenterSpy.viewLoadedCalled, "Presenter's viewLoaded should be called when view is loaded")
    }
    
    func testViewIsAppearing() {
        // Act
        viewController.viewIsAppearing(false)
        
        // Assert
        XCTAssertTrue(presenterSpy.viewIsAppearingCalled, "Presenter's viewIsAppearing should be called")
    }
    
    func testSetupInitialState() {
        // Act
        viewController.setupInitialState()
        
        // Assert
        XCTAssertNotNil(viewController.tasksTableView, "Tasks table view should be initialized")
        XCTAssertNotNil(viewController.searchController, "Search controller should be initialized")
        XCTAssertNotNil(viewController.activityIndicator, "Activity indicator should be initialized")
    }
    
    func testLoading() {
        // Act
        viewController.loading()
        
        // Assert
        XCTAssertTrue(viewController.activityIndicator.isAnimating, "Activity indicator should be animating when showing loading")
    }
    
    func testConfigure() {
        // Act
        viewController.configure(with: mockItems)
        
        // Assert
        XCTAssertFalse(viewController.activityIndicator.isAnimating, "Activity indicator should not be animating after configure")
    }
    
    func testShowError() {
        // Act
        viewController.showError()
        
        // Assert
        XCTAssertFalse(viewController.activityIndicator.isAnimating, "Activity indicator should not be animating after error")
        // Note: We can't easily test alert presentation in unit tests
    }
    
    func testUpdateUI() {
        // Act
        viewController.updateUI(with: mockItems)
        
        // Assert
        // Note: This is mostly testing that the method doesn't crash
        // For more thorough testing, we would need to mock the tasksTableView
    }
    
    func testSearchBarCancel() {
        // Act
        viewController.searchBarCancelButtonClicked(viewController.searchController.searchBar)
        
        // Assert
        XCTAssertTrue(presenterSpy.viewIsAppearingCalled, "Presenter's viewIsAppearing should be called on search cancel")
    }
    
    func testTasksTableViewActions() {
        // Arrange - Setup actions
        viewController.setupAction()
        
        // Act - Trigger edit action if possible
        if let onEditScreen = viewController.tasksTableView.onEditScreen {
            onEditScreen(mockItems[0])
        }
        
        // Assert
        XCTAssertTrue(presenterSpy.selectItemForEditingCalled, "Presenter's selectItemForEditing should be called")
        XCTAssertEqual(presenterSpy.lastItemForEditing?.id, mockItems[0].id, "Presenter should receive correct item")
        
        // Act - Trigger remove action if possible
        if let onRemoveTask = viewController.tasksTableView.onRemoveItem {
            onRemoveTask(mockItems[0])
        }
        
        // Assert
        XCTAssertTrue(presenterSpy.removeItemTappedCalled, "Presenter's removeItemTapped should be called")
        XCTAssertEqual(presenterSpy.lastItemToRemove?.id, mockItems[0].id, "Presenter should receive correct item")
        
        // Act - Trigger state change action if possible
        if let onChangeTDLState = viewController.tasksTableView.onChangeTDLState {
            onChangeTDLState(mockItems[0])
        }
        
        // Assert
        XCTAssertTrue(presenterSpy.changeItemStateCalled, "Presenter's changeItemState should be called")
        XCTAssertEqual(presenterSpy.lastItemToChangeState?.id, mockItems[0].id, "Presenter should receive correct item")
        
        // Act - Trigger filter action if possible
        if let onGetFilteredData = viewController.tasksTableView.onGetFilteredData {
            onGetFilteredData("Task 1")
        }
        
        // Assert
        XCTAssertTrue(presenterSpy.filterDataCalled, "Presenter's filterData should be called")
        XCTAssertEqual(presenterSpy.lastFilterQuery, "Task 1", "Presenter should receive correct query")
    }
    
    func testAddTaskButtonAction() {
        // Arrange - Setup actions
        viewController.setupAction()
        
        // Act - Trigger add action if possible
        if let onAddTaskButtonTapped = viewController.footerView.onAddTaskButtonTapped {
            onAddTaskButtonTapped()
        }
        
        // Assert
        XCTAssertTrue(presenterSpy.addNewTaskButtonTappedCalled, "Presenter's addNewTaskButtonTapped should be called")
    }
}
