//
//  AddItemPresenter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol AddItemViewOutput: TextInputProtocol {
    func viewLoaded()
    func eventHandler(_ event: AddItemEvent)
}

enum AddItemEvent {
    case saveButtonTapped
}

final class AddItemPresenter {

    private let interactor: AddItemInteractorInput
    private let router: RouterProtocol
    weak var view: AddItemViewInput?

    private var task: TDLItem?
    private var subtitle: String?
    private var title: String?

    // MARK: - Init
    init(interactor: AddItemInteractorInput, router: RouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func eventHandler(_ event: AddItemEvent) {
        switch event {
        case .saveButtonTapped:
            configureTask()
            sendNewTaskToStorage()
            router.pop()
        }
    }
}

// MARK: - AddItemViewOutput
extension AddItemPresenter: AddItemViewOutput {
    func handleTitleChange(title: String) {
        self.title = title
        checkButton()
    }
    
    func handleSubTitleChange(subTitle: String) {
        self.subtitle = subTitle
        checkButton()
    }
    
    func viewLoaded() {
        view?.setupInitialState()
        checkButton()
    }
}

// MARK: - Supporting methods
private extension AddItemPresenter {
    func configureTask() {
        guard let title, let subtitle else { Log.addItem.errorAlways("We have empty fields"); return }
        let tempID = Int.random(in: 0..<1_000_000)
        let date = configureDate()
        task = TDLItem(id: tempID, title: title, subtitle: subtitle, date: date, completed: false)
    }

    func configureDate() -> String {
        let date = Date.now
            .formatted(
                .dateTime
                    .day(.twoDigits)
                    .month(.twoDigits)
                    .year(.twoDigits)
                    .locale(Locale(identifier: "en_GB"))
            )
        return date
    }

    func sendNewTaskToStorage() {
        guard let task else { Log.addItem.errorAlways("We have empty fields"); return }
        interactor.addItem(task)
    }

    func checkButton() {
        guard let title, let subtitle else { Log.addItem.errorAlways("We have empty fields"); return }
        let isOk = !title.isEmpty && !subtitle.isEmpty
        view?.isSaveButtonEnable(isOk)
    }
}
