//
//  AddItemPresenter.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol AddItemViewOutput: AnyObject {
    func viewLoaded()
    func sendButtonTapped()
    func addedItemSubtitle(_ subtitle: String)
    func addedItemTitle(_ title: String)
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
}

// MARK: - AddItemViewOutput
extension AddItemPresenter: AddItemViewOutput {
    func viewLoaded() {
        view?.setupInitialState()
        checkButton()
    }

    func addedItemSubtitle(_ subtitle: String) {
        self.subtitle = subtitle
        checkButton()
    }
    
    func addedItemTitle(_ title: String) {
        self.title = title
        checkButton()
    }

    func sendButtonTapped() {
        configureTask()
        sendNewTaskToStorage()
        router.pop()
    }
}

// MARK: - Supporting methods
private extension AddItemPresenter {
    func configureTask() {
        guard let title, let subtitle else { print("We have empty fields"); return }
        let date = configureDate()
        let tempID = abs(UUID().hashValue % 1_000_000)
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
        guard let task else { return }
        interactor.addItem(task)
    }

    func checkButton() {
        guard let title, let subtitle else { return }
        let isOk = !title.isEmpty && !subtitle.isEmpty
        view?.isSaveButtonEnable(isOk)
    }
}
