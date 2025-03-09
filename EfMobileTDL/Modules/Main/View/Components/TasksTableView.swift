//
//  TasksTableView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit
import rswift

final class TasksTableView: UITableView {

    private var chosenCell: TaskTableViewCell?
    private var data: [TDLItem]?

    var onShowShareScreen: ((UIActivityViewController) -> Void)?
    var onEditScreen: ((TDLItem) -> Void)?
    var onRemoveItem: ((TDLItem) -> Void)?
    var onChangeTDLState: ((TDLItem) -> Void)?
    var onGetFilteredData: ((String) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getData(_ data: [TDLItem], animated: Bool = true) {
        if self.data != data {
            let deletedIndexes = getIndexesOfDeletedItems(data)
            removeRowsOrUpdateCells(deletedIndexes)
        }
    }

    func filterData(by text: String) {
        onGetFilteredData?(text)
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
        let item = data?[indexPath.row]

        guard let item else { return cell }
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

            let editAction = UIAction(title: AppConstants.L.edit(), image: AppConstants.SystemImages.edit) { [weak self] _ in
                self?.editTask(at: indexPath)
            }

            let shareAction = UIAction(title: AppConstants.L.share(), image: AppConstants.SystemImages.share) { [weak self] _ in
                self?.shareTask(at: indexPath)
            }

            let deleteAction = UIAction(title: AppConstants.L.delete(), image: AppConstants.SystemImages.delete, attributes: .destructive) { [weak self] _ in
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
        let textToShare = AppConstants.L.shareTask(task.title, task.subtitle)
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        onShowShareScreen?(activityVC)
    }

    func deleteTask(at indexPath: IndexPath) {
        guard let task = data?[indexPath.row] else { print("We have problem with indexPath"); return }
        onRemoveItem?(task)
    }
}


// MARK: - Supporting methods
private extension TasksTableView {
    func removeRowsOrUpdateCells(_ indexes: [IndexPath]) {
        if !indexes.isEmpty {
            removeRows(indexes)
        } else {
            reloadData()
        }
    }

    func getIndexesOfDeletedItems(_ newData: [TDLItem]) -> [IndexPath] {
        let oldData = self.data ?? []
        self.data = newData

        let deletedIndexes = oldData.enumerated().compactMap { (index, item) -> IndexPath? in
            return newData.contains(where: { $0.id == item.id }) ? nil : IndexPath(row: index, section: 0)
        }
        return deletedIndexes
    }

     func removeRows(_ deletedIndexes: [IndexPath]) {
        beginUpdates()
        deleteRows(at: deletedIndexes, with: .automatic)
        endUpdates()
    }
}
