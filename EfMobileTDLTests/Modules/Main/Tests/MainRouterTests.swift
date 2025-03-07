import XCTest
@testable import EfMobileTDL

// MARK: - ModuleFactory Spy
final class ModuleFactorySpyRouter: ModuleFactoryProtocol {
    var makeModuleCalled = false
    var lastModuleType: AppModule?
    var viewControllerToReturn: UIViewController = UIViewController()

    func makeModule(_ type: AppModule) -> UIViewController {
        makeModuleCalled = true
        lastModuleType = type
        return viewControllerToReturn
    }
}


final class MainRouterTests: XCTestCase {
    // MARK: - Properties
    
    private var router: MainRouter!
    private var moduleFactorySpy: ModuleFactorySpyRouter!
    private var navigationController: UINavigationController!
    private var viewController: UIViewController!
    
    // MARK: - Test Lifecycle
    
    override func setUp() {
        super.setUp()
        viewController = UIViewController()
        navigationController = UINavigationController(rootViewController: viewController)
        moduleFactorySpy = ModuleFactorySpyRouter()
        router = MainRouter(moduleFactory: moduleFactorySpy, navigationController: navigationController)
    }
    
    override func tearDown() {
        router = nil
        moduleFactorySpy = nil
        navigationController = nil
        viewController = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testGoToAddItemModule() {
        // Arrange
        let addItemVC = UIViewController()
        moduleFactorySpy.viewControllerToReturn = addItemVC
        
        // Act
        router.goToAddItemModule()
        
        // Assert
        XCTAssertTrue(moduleFactorySpy.makeModuleCalled, "ModuleFactory's makeModule should be called")
        XCTAssertEqual(moduleFactorySpy.lastModuleType, .addItem, "ModuleFactory should request add item module")
        
        // Since the navigation happens in the same thread in tests
        XCTAssertEqual(navigationController.topViewController, addItemVC, "Navigation controller should show the add item view controller")
    }
    
    func testGoToEditItemModule() {
        // Arrange
        let editItemVC = UIViewController()
        moduleFactorySpy.viewControllerToReturn = editItemVC
        
        // Act
        router.goToEditItemModule()
        
        // Assert
        XCTAssertTrue(moduleFactorySpy.makeModuleCalled, "ModuleFactory's makeModule should be called")
        XCTAssertEqual(moduleFactorySpy.lastModuleType, .editItem, "ModuleFactory should request edit item module")
        
        // Since the navigation happens in the same thread in tests
        XCTAssertEqual(navigationController.topViewController, editItemVC, "Navigation controller should show the edit item view controller")
    }
}
