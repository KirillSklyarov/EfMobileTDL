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
    var onEditScreen: ((TDL) -> Void)?

    private var data: [TDL]?
    private var filteredData: [TDL]?
    private var isFiltering = false

    var onRemoveTask: ((TDL) -> Void)?
    var onChangeTDLState: ((TDL) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
//        loadDataFromStorage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getData(_ data: [TDL]) {
        self.data = data
        reloadData()
    }

//    func loadDataFromStorage() {
//        self.data = TaskOld.getData()
//        reloadData()
//    }

    func filterData(by text: String) {
//        print("text: \(text)")
//        self.data = TaskOld.getData()

        if !text.isEmpty {
//            self.data = TaskOld.getData()
            filteredData = data?.filter { $0.title.lowercased().contains(text.lowercased()) }
            isFiltering.toggle()
//            self.data = filteredData
//           print("data \(data)")
        }

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
        isFiltering ? filteredData?.count ?? 0 : data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(indexPath) as TaskTableViewCell
        guard let item = data?[indexPath.row] else { return cell }
        cell.configureCell(with: item)

        cell.onTaskStateChanged = { [weak self] in
            self?.onChangeTDLState?(item)
        }

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
        guard let task = data?[indexPath.row] else { print("We have problem with indexPath"); return }
        onEditScreen?(task)
    }

    func shareTask(at indexPath: IndexPath) {
        guard let task = data?[indexPath.row] else { print("We have problem with indexPath"); return }
        let textToShare = "Задача: \(task.title)\nОписание: \(task.subtitle)\n"
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        onShowShareScreen?(activityVC)
    }

    func deleteTask(at indexPath: IndexPath) {
        guard let task = data?[indexPath.row] else { print("We have problem with indexPath"); return }
        onRemoveTask?(task)

//        TaskOld.removeTask(task)
        data?.remove(at: indexPath.row)
        beginUpdates()
        deleteRows(at: [indexPath], with: .automatic)
        endUpdates()
    }
}
