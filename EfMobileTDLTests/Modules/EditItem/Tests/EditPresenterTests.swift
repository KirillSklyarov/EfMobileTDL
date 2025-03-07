//
//  PresenterTests.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import XCTest
@testable import EfMobileTDL

final class PresenterTests: XCTestCase {

    var viewController: EditItemViewController!
    var dataManager: CoreDataManagerProtocol!
    var interactor: EditItemInteractorSpy!
    var presenter: EditItemPresenterSpy!

    override func setUp() {
        super.setUp()
        dataManager = CoreDataManager()
        interactor = EditItemInteractorSpy()
        presenter = EditItemPresenterSpy(interactor: interactor)
        viewController = EditItemViewController(output: presenter)

        interactor.output = presenter
        presenter.view = viewController
    }

    override func tearDown() {
        viewController = nil
        dataManager = nil
        interactor = nil
        presenter = nil
        super.tearDown()
    }

    func testSetupInitialStateAndShowLoading() {
        viewController.viewDidLoad()
        XCTAssertTrue(presenter.viewLoadedCalled)
    }
}
