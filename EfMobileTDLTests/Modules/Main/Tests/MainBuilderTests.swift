import XCTest
@testable import EfMobileTDL

// MARK: - Module Factory Spy
final class ModuleFactorySpyBuilder: ModuleFactoryProtocol {
    var makeModuleCalled = false
    var lastModuleType: AppModule?

    func makeModule(_ module: AppModule) -> UIViewController {
        makeModuleCalled = true
        lastModuleType = module
        return UIViewController()
    }
}

final class MainBuilderTests: XCTestCase {
    // MARK: - Properties
    
    private var builder: MainModuleBuilder!
    private var coreDataManagerSpy: CoreDataManagerSpy!
    private var routerFactorySpy: RouterFactorySpyBuilder!
    private var networkServiceSpy: NetworkServiceSpy!
    private var navigationController: UINavigationController!
    
    // MARK: - Test Lifecycle
    
    override func setUp() {
        super.setUp()
        navigationController = UINavigationController()
        coreDataManagerSpy = CoreDataManagerSpy()
        routerFactorySpy = RouterFactorySpyBuilder()
        networkServiceSpy = NetworkServiceSpy()
        builder = MainModuleBuilder(
            dataManager: coreDataManagerSpy,
            routerFactory: routerFactorySpy,
            networkService: networkServiceSpy
        )
    }
    
    override func tearDown() {
        builder = nil
        coreDataManagerSpy = nil
        routerFactorySpy = nil
        networkServiceSpy = nil
        navigationController = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testBuild() {
        // Act
        let viewController = builder.build()

        // Assert
        XCTAssertNotNil(viewController, "Should return a view controller")
        XCTAssertTrue(viewController is MainViewController, "Should return a MainViewController instance")
        
        // Verify the VIPER connections
        let mainVC = viewController
        XCTAssertNotNil(mainVC.output, "View controller should have an output (presenter)")
        
        guard let presenter = mainVC.output as? MainPresenter else {
            XCTFail("Output should be MainPresenter instance")
            return
        }
        
        XCTAssertTrue(presenter.view === mainVC, "Presenter should reference the view controller")
        
        guard let interactor = mirror(of: presenter, for: "interactor") as? MainInteractor else {
            XCTFail("Presenter should have MainInteractor instance")
            return
        }
        
        XCTAssertTrue(interactor.output === presenter, "Interactor should reference the presenter")
        
        // Check if dataManager is the same instance
        if let dataManager = mirror(of: interactor, for: "dataManager") as? CoreDataManagerSpy {
            XCTAssertTrue(dataManager === coreDataManagerSpy, "Interactor should have the correct core data manager")
        } else {
            XCTFail("Interactor should have CoreDataManagerSpy instance")
        }
        
        // Check if networkService is the same instance
        if let networkService = mirror(of: interactor, for: "networkService") as? NetworkServiceSpy {
            XCTAssertTrue(networkService === networkServiceSpy, "Interactor should have the correct network service")
        } else {
            XCTFail("Interactor should have NetworkServiceSpy instance")
        }
        
        guard let router = mirror(of: presenter, for: "router") as? MainRouterProtocol else {
            XCTFail("Presenter should have MainRouter instance")
            return
        }
        
        XCTAssertTrue(routerFactorySpy.makeMainRouterCalled, "RouterFactory's makeMainRouter should be called")
    }
    
    // Helper function to access private properties using Mirror
    private func mirror(of object: Any, for key: String) -> Any? {
        let mirror = Mirror(reflecting: object)
        return mirror.children.first { $0.label == key }?.value
    }
}

// MARK: - RouterFactory Spy

final class RouterFactorySpyBuilder: RouterFactoryProtocol {
    var makeMainRouterCalled = false
    var makeEditItemRouterCalled = false
    var makeAddItemModuleCalled = false
    var setModuleFactoryCalled = false
    
    var moduleFactory: ModuleFactoryProtocol?
    var navigationController: UINavigationController?
    
    func makeMainRouter() -> MainRouterProtocol {
        makeMainRouterCalled = true
        return MainRouter(
            moduleFactory: ModuleFactorySpyBuilder(),
            navigationController: navigationController ?? UINavigationController()
        )
    }
    
    func makeEditItemRouter() -> EditItemRouter {
        makeEditItemRouterCalled = true
        return EditItemRouter(navigationController: navigationController ?? UINavigationController())
    }
    
    func makeAddItemModule() -> AddItemRouter {
        makeAddItemModuleCalled = true
        return AddItemRouter(navigationController: navigationController ?? UINavigationController())
    }
    
    func setModuleFactory(_ moduleFactory: ModuleFactoryProtocol?) {
        setModuleFactoryCalled = true
        self.moduleFactory = moduleFactory
    }
}
