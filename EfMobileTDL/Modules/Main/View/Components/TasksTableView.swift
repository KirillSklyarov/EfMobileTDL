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
    var onEditScreen: ((Task) -> Void)?

    private var data: [Task]?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
        loadDataFromStorage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadDataFromStorage() {
        self.data = Task.getData()
//        print("Data first: \(data?.first)")
//        sleep(1)
//        print("Storage data first: \(Task.getData().first)")
        reloadData()
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
        data?.count ?? 0
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

            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
                self?.editTask(at: indexPath)
            }

            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
                self?.shareTask(at: indexPath)
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

// MARK: - Menu actions
private extension TasksTableView {
    func editTask(at indexPath: IndexPath) {
        let task = Task.data[indexPath.row]
        onEditScreen?(task)
    }

    func shareTask(at indexPath: IndexPath) {
        let task = Task.data[indexPath.row]
        let textToShare = "Задача: \(task.title)\nОписание: \(task.subtitle)\n"
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        onShowShareScreen?(activityVC)
    }

    func deleteTask(at indexPath: IndexPath) {
        Task.data.remove(at: indexPath.row)
        data?.remove(at: indexPath.row)
        beginUpdates()
        deleteRows(at: [indexPath], with: .automatic)
        endUpdates()
    }
}
