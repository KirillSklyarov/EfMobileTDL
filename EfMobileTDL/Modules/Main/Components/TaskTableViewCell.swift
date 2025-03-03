//
//  TaskTableViewCell.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppConstants.Fonts.regular16
        label.textColor = AppConstants.Colors.white
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppConstants.Fonts.regular12
        label.textColor = AppConstants.Colors.white
        label.numberOfLines = 2
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = AppConstants.Fonts.regular12
        label.textColor = AppConstants.Colors.gray
        return label
    }()

    private lazy var contentStack = AppStackView([titleLabel, subTitleLabel, dateLabel], axis: .vertical, spacing: 6)

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
}

// MARK: - Configure cell
private extension TaskTableViewCell {
    func setupCell() {
        backgroundColor = .clear
        contentView.addSubviews(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: AppConstants.Insets.small),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -AppConstants.Insets.small)
        ])
    }
}
