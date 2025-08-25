//
//  FooterView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

final class FooterView: UIView {

    private lazy var tasksLabel = AppLabel(type: .footerLabel)
    private lazy var addTaskButton = AppButton(style: .addTask)

    var onAddTaskButtonTapped: (() -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI(with itemsCount: Int) {
        tasksLabel.text = "\(itemsCount) \(AppConstants.L.tasks())"
    }
}

// MARK: - Setup UI
private extension FooterView {
    func configure() {
        backgroundColor = AppConstants.Colors.darkGray
        addSubviews(tasksLabel, addTaskButton)

        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            tasksLabel.topAnchor.constraint(equalTo: topAnchor, constant: AppConstants.Insets.medium),
            tasksLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            addTaskButton.centerYAnchor.constraint(equalTo: tasksLabel.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppConstants.Insets.medium),
        ])
    }
}

// MARK: - Setup Action
private extension FooterView {
    func setupAction() {
        addTaskButton.onButtonTapped = { [weak self] in
            self?.onAddTaskButtonTapped?()
        }
    }
}
