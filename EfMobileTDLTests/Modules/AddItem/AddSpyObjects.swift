//
//  SpyObjects.swift
//  EfMobileTDLTests
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import UIKit
@testable import EfMobileTDL
import CoreData

// MARK: - AddItem module spy objects
final class AddItemViewSpy: AddItemViewInput {
    var setupInitialStateCalled = false
    var isSaveButtonEnableCalled = false
    var lastSaveButtonState: Bool?

    func setupInitialState() {
        setupInitialStateCalled = true
    }

    func isSaveButtonEnable(_ isEnabled: Bool) {
        isSaveButtonEnableCalled = true
        lastSaveButtonState = isEnabled
    }
}

final class AddItemPresenterSpy: AddItemViewOutput {
    var viewLoadedCalled = false
    var sendButtonTappedCalled = false
    var addedItemSubtitleCalled = false
    var addedItemTitleCalled = false
    var lastSubtitle: String?
    var lastTitle: String?

    func viewLoaded() {
        viewLoadedCalled = true
    }

    func sendButtonTapped() {
        sendButtonTappedCalled = true
    }

    func addedItemSubtitle(_ subtitle: String) {
        addedItemSubtitleCalled = true
        lastSubtitle = subtitle
    }

    func addedItemTitle(_ title: String) {
        addedItemTitleCalled = true
        lastTitle = title
    }
}



final class RouterSpy: RouterProtocol {
    var navigationController: UINavigationController?
    var popCalled = false
    var pushCalled = false
    var lastPushedViewController: UIViewController?

    func pop() {
        popCalled = true
    }

    func push(_ viewController: UIViewController) {
        pushCalled = true
        lastPushedViewController = viewController
    }
}

// Mock for CoreDataManager
final class MockCoreDataManager: CoreDataManagerProtocol {
    func fetchData(_ context: NSManagedObjectContext?) -> [TDL] {
        return []
    }
    
    func getItemToEdit() -> TDLItem? {
        return nil
    }

    func setItemToEdit(_ item: TDLItem) {
        0
    }

    func saveDataInCoreData(tdlItems: [TDLItem]) {
        0
    }

    func removeItem(_ item: EfMobileTDL.TDLItem, completion: (() -> Void)?) {
        0
    }

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

// Mock for UINavigationController
final class MockNavigationController: UINavigationController {
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
