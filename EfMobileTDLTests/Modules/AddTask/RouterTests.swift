//
//  RouterTests.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import XCTest
@testable import EfMobileTDL

final class AddItemRouterTests: XCTestCase {
    
    var router: AddItemRouter!
    var mockNavigationController: MockNavigationController!
    
    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController()
        router = AddItemRouter(navigationController: mockNavigationController)
    }
    
    override func tearDown() {
        router = nil
        mockNavigationController = nil
        super.tearDown()
    }
    
    func testPop() {
        // When
        router.pop()
        
        // Then
        XCTAssertTrue(mockNavigationController.popViewControllerCalled, "Navigation controller's popViewController should be called")
    }
    
    func testPush() {
        // Given
        let viewController = UIViewController()
        
        // When
        router.push(viewController)
        
        // Then
        XCTAssertTrue(mockNavigationController.pushViewControllerCalled, "Navigation controller's pushViewController should be called")
        XCTAssertEqual(mockNavigationController.lastPushedViewController, viewController, "The correct view controller should be pushed")
    }
}

// Mock for UINavigationController
class MockNavigationController: UINavigationController {
    var popViewControllerCalled = false
    var pushViewControllerCalled = false
    var lastPushedViewController: UIViewController?
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return nil
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCalled = true
        lastPushedViewController = viewController
        super.pushViewController(viewController, animated: animated)
    }
}