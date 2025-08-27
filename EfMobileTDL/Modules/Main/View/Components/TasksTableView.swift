//
//  TasksTableView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

enum Section {
    case main
}

final class TasksTableView: UITableView {

    private var diffDataSource: UITableViewDiffableDataSource<Section, TDLItem>!

    var onShowShareScreen: ((UIActivityViewController) -> Void)?
    var onEditScreen: ((TDLItem) -> Void)?
    var onRemoveItem: ((TDLItem) -> Void)?
    var onChangeTDLState: ((TDLItem) -> Void)?

    // MARK: - Init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupTableView()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(tasks: [TDLItem]) {
        setupSnapshot(data: tasks)
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
        estimatedRowHeight = 90
        rowHeight = UITableView.automaticDimension
        tableHeaderView = UIView()

        delegate = self
    }

    func setupTableView() {
        registerCell(TaskTableViewCell.self)
        diffDataSource = UITableViewDiffableDataSource(tableView: self) { [weak self] tableView, indexPath, task in
            guard let self else { Log.app.errorAlways("self is nil"); return UITableViewCell() }
            let cell = tableView.dequeueCell(indexPath) as TaskTableViewCell
            cell.configureCell(with: task)

            cell.onTaskStateChanged = { [weak self] in
                self?.onChangeTDLState?(task)
            }

            return cell
        }
    }

    func setupSnapshot(data: [TDLItem], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, TDLItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)

        DispatchQueue.main.async { [weak self] in
            self?.diffDataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}

// MARK: - UITableViewDelegate
extension TasksTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let item = diffDataSource.itemIdentifier(for: indexPath) else {
            Log.app.errorAlways("Could not find item for indexPath: \(indexPath)")
            return nil
        }

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in

            let editAction = UIAction(title: AppConstants.L.edit(), image: AppConstants.SystemImages.edit) { [weak self] _ in
                self?.onEditScreen?(item)
            }

            let shareAction = UIAction(title: AppConstants.L.share(), image: AppConstants.SystemImages.share) { [weak self] _ in
                self?.shareTask(item)
            }

            let deleteAction = UIAction(title: AppConstants.L.delete(), image: AppConstants.SystemImages.delete, attributes: .destructive) { [weak self] _ in
                self?.deleteTask(item)
            }

            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}

// MARK: - Menu actions
private extension TasksTableView {
    func shareTask(_ item: TDLItem) {
        let textToShare = AppConstants.L.shareTask(item.title, item.subtitle)
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        onShowShareScreen?(activityVC)
    }

    func deleteTask(_ item: TDLItem) {
        var snap = diffDataSource.snapshot()
        snap.deleteItems([item])
        diffDataSource.apply(snap, animatingDifferences: true)
        onRemoveItem?(item)
    }
}
