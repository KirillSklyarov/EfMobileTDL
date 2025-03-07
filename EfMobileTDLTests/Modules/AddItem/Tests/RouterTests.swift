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
        router.pop()
        XCTAssertTrue(mockNavigationController.popViewControllerCalled)
    }
    
    func testPush() {
        let viewController = UIViewController()
        router.push(to: viewController)

        XCTAssertTrue(mockNavigationController.pushViewControllerCalled)
        XCTAssertEqual(mockNavigationController.lastPushedViewController, viewController)
    }
}
