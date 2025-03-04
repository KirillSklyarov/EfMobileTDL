//
//  TaskTableViewCell.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private lazy var titleLabel = AppLabel(type: .title)
    private lazy var subTitleLabel = AppLabel(type: .subtitle)
    private lazy var dateLabel = AppLabel(type: .date)
    private lazy var checkView = CheckmarkView()

    private lazy var textStack = AppStackView([titleLabel, subTitleLabel, dateLabel], axis: .vertical, spacing: 6, distribution: .equalSpacing)

    private lazy var contentStack = AppStackView([checkView, textStack], axis: .horizontal, spacing: 8)

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension TaskTableViewCell {
    func configureCell(with task: Task) {
        titleLabel.text = task.title
        subTitleLabel.text = task.subtitle
        dateLabel.text = task.date
    }

    func isHideCheckmarkView(_ bool: Bool) {
        checkView.alpha = bool ? 0 : 1
    }
}

// MARK: - Configure cell
private extension TaskTableViewCell {
    func setupCell() {
        backgroundColor = AppConstants.Colors.black
        contentView.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppConstants.Insets.small),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppConstants.Insets.small)
        ])
    }
}
