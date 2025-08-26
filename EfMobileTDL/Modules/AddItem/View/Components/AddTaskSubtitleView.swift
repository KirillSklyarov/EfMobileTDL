//
//  AddTaskSubtitleView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

final class AddTaskSubtitleView: UIView {

    private lazy var subtitleTextField = UITextView()

    private(set) var textViewText: String?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getTextViewText() -> String? {
        textViewText
    }

    func setTextViewTextColor(_ color: UIColor) {
        subtitleTextField.textColor = color
    }

    func setTextViewDelegate(_ delegate: UITextViewDelegate) {
        subtitleTextField.delegate = delegate
    }

    func setTextViewText(_ text: String?) {
        subtitleTextField.text = text
    }
}

// MARK: - Setup UI
private extension AddTaskSubtitleView {
    func setupUI() {
        layer.cornerRadius = AppConstants.CornerRadius.small
        backgroundColor = AppConstants.Colors.darkGray

        setupTextView()

        addSubviews(subtitleTextField)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            subtitleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            subtitleTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            subtitleTextField.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            subtitleTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),

            subtitleTextField.heightAnchor.constraint(equalToConstant: AppConstants.Height.subTitleTextView),
        ])
    }

    func setupTextView() {
        subtitleTextField.backgroundColor = AppConstants.Colors.darkGray
        subtitleTextField.font = AppConstants.Fonts.regular16
        subtitleTextField.text = AppConstants.L.addTaskSubtitle()
        subtitleTextField.textColor = AppConstants.Colors.gray
    }
}
