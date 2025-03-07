//
//  AddItemInteractor.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol AddItemInteractorInput: AnyObject {
    func addItem(_ item: TDLItem)
}

final class AddItemInteractor {

    private let dataManager: CoreDataManagerProtocol
    weak var presenter: AddItemViewOutput?

    init(dataManager: CoreDataManagerProtocol) {
        self.dataManager = dataManager
    }
}

// MARK: - AddItemInteractorInput
extension AddItemInteractor: AddItemInteractorInput {
    func addItem(_ item: TDLItem) {
        dataManager.addNewItem(item)
    }
}
