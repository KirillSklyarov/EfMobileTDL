//
//  MainActionBinder.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 26.08.2025.
//

import UIKit

protocol MainActionBinding {
    func bind(tasksTableView: TasksTableView, footerView: FooterView)
    func setVC(_ viewController: UIViewController)
}

final class MainActionBinder: MainActionBinding {

    private weak var viewController: UIViewController?
    private let output: MainViewOutput

    init(output: MainViewOutput) {
        self.output = output
    }

    func setVC(_ viewController: UIViewController) {
        self.viewController = viewController
    }

    func bind(tasksTableView: TasksTableView, footerView: FooterView) {
        tasksTableView.onShowShareScreen = { [weak self] activityVC in
            self?.viewController?.present(activityVC, animated: true)
        }

        tasksTableView.onEditScreen = { [weak self] task in
            guard let self else { return }
            output.eventHandler(.editTask(task))
        }

        tasksTableView.onRemoveItem = { [weak self] task in
            guard let self else { return }
            output.eventHandler(.deleteItem(task))
        }

        tasksTableView.onChangeTDLState = { [weak self] task in
            guard let self else { return }
            output.eventHandler(.changeItemState(task))
        }

        footerView.onAddTaskButtonTapped = { [weak self] in
            guard let self else { return }
            output.eventHandler(.addNewTask)
        }
    }
}
