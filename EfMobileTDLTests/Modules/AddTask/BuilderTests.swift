//
//  BuilderTests.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import XCTest
@testable import EfMobileTDL

final class AddItemBuilderTests: XCTestCase {
    
    var builder: AddItemModuleBuilder!
    var mockDataManager: MockCoreDataManager!
    var mockRouterFactory: MockRouterFactory!
    
    override func setUp() {
        super.setUp()
        mockDataManager = MockCoreDataManager()
        mockRouterFactory = MockRouterFactory()
        builder = AddItemModuleBuilder(dataManager: mockDataManager, routerFactory: mockRouterFactory)
    }
    
    override func tearDown() {
        builder = nil
        mockDataManager = nil
        mockRouterFactory = nil
        super.tearDown()
    }
    
    func testBuild() {
        // When
        let viewController = builder.build()
        
        // Then
        XCTAssertTrue(viewController is AddItemViewController, "Builder should return an AddItemViewController")
        
        // Test that RouterFactory was called
        XCTAssertTrue(mockRouterFactory.makeRouterCalled, "RouterFactory's makeRouter should be called")
        XCTAssertEqual(mockRouterFactory.lastRouterType, .addItem, "RouterFactory should create an addItem router")
        
        // Test that presenter is properly set up
        let mirror = Mirror(reflecting: viewController)
        guard let output = mirror.children.first(where: { $0.label == "output" })?.value else {
            XCTFail("ViewController should have an output property")
            return
        }
        
        XCTAssertTrue(output is AddItemPresenter, "ViewController's output should be an AddItemPresenter")
        
        // Test that dependencies are properly injected
        if let presenter = output as? AddItemPresenter {
            let presenterMirror = Mirror(reflecting: presenter)
            
            // Check interactor
            guard let interactor = presenterMirror.children.first(where: { $0.label == "interactor" })?.value else {
                XCTFail("Presenter should have an interactor property")
                return
            }
            XCTAssertTrue(interactor is AddItemInteractor, "Presenter's interactor should be an AddItemInteractor")
            
            // Check router
            guard let router = presenterMirror.children.first(where: { $0.label == "router" })?.value else {
                XCTFail("Presenter should have a router property")
                return
            }
            XCTAssertTrue(router is RouterProtocol, "Presenter's router should be a RouterProtocol")
            
            // Check view reference
            guard let view = presenterMirror.children.first(where: { $0.label == "view" })?.value else {
                XCTFail("Presenter should have a view property")
                return
            }
            XCTAssertTrue(view is AddItemViewController, "Presenter's view should be an AddItemViewController")
        } else {
            XCTFail("Could not cast output to AddItemPresenter")
        }
    }
}

// Mock for RouterFactory
class MockRouterFactory: RouterFactoryProtocol {
    var makeRouterCalled = false
    var lastRouterType: RouterType?
    
    func makeRouter(_ type: RouterType) -> RouterProtocol {
        makeRouterCalled = true
        lastRouterType = type
        
        let mockNavController = MockNavigationController()
        return AddItemRouter(navigationController: mockNavController)
    }
}