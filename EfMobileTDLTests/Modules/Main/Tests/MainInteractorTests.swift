import XCTest
import CoreData
@testable import EfMobileTDL

final class MainInteractorTests: XCTestCase {
    // MARK: - Properties
    private var interactor: MainInteractor!
    private var coreDataManagerSpy: CoreDataManagerSpy!
    private var networkServiceSpy: NetworkServiceSpy!
    private var presenterSpy: MainPresenterSpy!
    
    private let mockItems: [TDLItem] = [
        TDLItem(id: 1, title: "Task 1", subtitle: "Subtitle 1", date: Date().description, completed: false),
        TDLItem(id: 2, title: "Task 2", subtitle: "Subtitle 2", date: Date().description, completed: true)
    ]
    
    private let mockTDLs: [TDL] = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let tdl1 = TDL(context: context)
        tdl1.id = 1
        tdl1.title = "Task 1"
        tdl1.subtitle = "Subtitle 1"
        tdl1.date = Date().description
        tdl1.completed = false
        
        let tdl2 = TDL(context: context)
        tdl2.id = 2
        tdl2.title = "Task 2"
        tdl2.subtitle = "Subtitle 2"
        tdl2.date = Date().description
        tdl2.completed = true
        
        return [tdl1, tdl2]
    }()
    
    // MARK: - Test Lifecycle
    
    override func setUp() {
        super.setUp()
        coreDataManagerSpy = CoreDataManagerSpy()
        networkServiceSpy = NetworkServiceSpy()
        presenterSpy = MainPresenterSpy()
        interactor = MainInteractor(dataManager: coreDataManagerSpy, networkService: networkServiceSpy)
        interactor.output = presenterSpy
    }
    
    override func tearDown() {
        interactor = nil
        coreDataManagerSpy = nil
        networkServiceSpy = nil
        presenterSpy = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    func testSetUserTasks() {
        // Act
        interactor.setUserTasks(mockItems)
        
        // Assert
        XCTAssertEqual(interactor.data.count, mockItems.count, "Data should be set correctly")
    }
    
    func testAddTask() {
        // Arrange
        let newItem = TDLItem(id: 3, title: "New Task", subtitle: "New Subtitle", date: Date().description, completed: false)
        
        // Act
        interactor.addTask(newItem)
        
        // Wait for async operation to complete
        let expectation = XCTestExpectation(description: "Wait for add task")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(interactor.data.contains { $0.id == newItem.id }, "New item should be added to the data array")
    }
    
    func testRemoveTask() {
        // Arrange
        interactor.data = mockItems
        
        // Act
        interactor.removeTask(mockItems[0])
        
        // Wait for async operation to complete
        let expectation = XCTestExpectation(description: "Wait for remove task")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(coreDataManagerSpy.removeItemCalled, "CoreDataManager's removeItem should be called")
        XCTAssertEqual(coreDataManagerSpy.lastItemRemoved?.id, mockItems[0].id, "CoreDataManager should receive the correct item")
        XCTAssertTrue(presenterSpy.dataLoadedCalled, "Presenter's dataLoaded should be called after removal")
    }
    
    func testChangeTaskState() {
        // Arrange
        interactor.data = mockItems
        
        // Act
        interactor.changeTaskState(mockItems[0])
        
        // Wait for async operation to complete
        let expectation = XCTestExpectation(description: "Wait for change task state")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(coreDataManagerSpy.updateItemCalled, "CoreDataManager's updateItem should be called")
    }
    
    func testFilterData() {
        // Arrange
        interactor.data = mockItems
        
        // Act
        let filteredData = interactor.filterData(by: "Subtitle 1")

        // Assert
        XCTAssertEqual(filteredData.count, 1, "Should filter data correctly")
        XCTAssertEqual(filteredData[0].id, mockItems[0].id, "Should return correct filtered item")
    }
    
    func testGetIndex() {
        // Arrange
        interactor.data = mockItems
        
        // Act
        let index = interactor.getIndex(of: mockItems[0])
        
        // Assert
        XCTAssertEqual(index, 0, "Should return correct index")
    }
    
    func testGetNewDataFromCD() {
        // Arrange
        coreDataManagerSpy.dataToReturn = mockTDLs
        
        // Act
        interactor.getNewDataFromCD()
        
        // Assert
        XCTAssertTrue(coreDataManagerSpy.fetchDataCalled, "CoreDataManager's fetchData should be called")
        XCTAssertEqual(interactor.data.count, mockTDLs.count, "Interactor's data should be updated")
        XCTAssertTrue(presenterSpy.dataLoadedCalled, "Presenter's dataLoaded should be called")
        XCTAssertEqual(presenterSpy.lastDataLoaded?.count, mockTDLs.count, "Presenter should receive correct data")
    }
    
    func testSelectItemForEditing() {
        // Act
        interactor.selectItemForEditing(mockItems[0])
        
        // Assert
        XCTAssertTrue(coreDataManagerSpy.setItemToEditCalled, "CoreDataManager's setItemToEdit should be called")
        XCTAssertEqual(coreDataManagerSpy.lastItemToEdit?.id, mockItems[0].id, "CoreDataManager should receive correct item")
    }
    
    @MainActor
    func testFetchData() async {
        // Arrange
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
        networkServiceSpy.dataToReturn = mockItems
        
        // Act
        await interactor.fetchData()
        
        // Assert
        XCTAssertTrue(networkServiceSpy.fetchDataFromServerCalled, "NetworkService's fetchDataFromServer should be called")
        XCTAssertTrue(coreDataManagerSpy.saveDataInCoreDataCalled, "CoreDataManager's saveDataInCoreData should be called")
        XCTAssertEqual(interactor.data.count, mockItems.count, "Interactor's data should be updated")
        
        // Reset user defaults
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
    }
    
    func testFetchDataWithError() async {
        // Arrange
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
        networkServiceSpy.errorToThrow = TestError.generic
        
        // Act
        await interactor.fetchData()
        
        // Assert
        XCTAssertTrue(networkServiceSpy.fetchDataFromServerCalled, "NetworkService's fetchDataFromServer should be called")
        XCTAssertTrue(presenterSpy.getErrorCalled, "Presenter's getError should be called on error")
        
        // Reset user defaults
        UserDefaults.standard.set(false, forKey: "hasLaunchedBefore")
    }
}
