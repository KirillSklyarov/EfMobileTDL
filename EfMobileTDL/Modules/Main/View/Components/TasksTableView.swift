//
//  TasksTableView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

final class TasksTableView: UITableView {

    var chosenCell: TaskTableViewCell?
    var onShowShareScreen: ((UIActivityViewController) -> Void)?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension TasksTableView {
    func setupUI() {
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        allowsSelection = false
        separatorStyle = .singleLine
        separatorColor = AppConstants.Colors.darkGray
        estimatedRowHeight = 90/800
        rowHeight = UITableView.automaticDimension
        tableHeaderView = UIView()

        registerCell(TaskTableViewCell.self)

        dataSource = self
        delegate = self
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TasksTableView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Task.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as TaskTableViewCell
        let item = Task.data[indexPath.row]
        cell.configureCell(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return nil }
        cell.isHideCheckmarkView(true)
        chosenCell = cell

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { _ in
                print("Edit")
            }

            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                let task = Task.data[indexPath.row]
                self?.shareTask(task, from: cell)
            }

            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.deleteTask(at: indexPath)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }

    // Показываем вью после закрытия меню
    func tableView(_ tableView: UITableView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: (any UIContextMenuInteractionAnimating)?) {
        chosenCell?.isHideCheckmarkView(false)
        chosenCell = nil
    }
}

private extension TasksTableView {
    func deleteTask(at indexPath: IndexPath) {
        Task.data.remove(at: indexPath.row)
        beginUpdates()
        deleteRows(at: [indexPath], with: .automatic)
        endUpdates()
    }
    
    func shareTask(_ task: Task, from sourceView: UIView) {
        let textToShare = "Задача: \(task.title)\nОписание: \(task.subtitle)\n"
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        onShowShareScreen?(activityVC)
    }
}
