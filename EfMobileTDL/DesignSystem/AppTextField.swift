//
//  AppTextField.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

enum AppTextFieldType: String {
    case title
    case subtitle
    case addTaskTitle = "enterTaskTitle"
    case addTaskSubtitle = "enterTaskSubtitle"

    var localizedString: String { rawValue.localized }
}

final class AppTextField: UITextField {

    private let height: CGFloat = AppConstants.Height.textField

    // MARK: - Init
    init(type: AppTextFieldType) {
        super.init(frame: .zero)
        configure(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure
private extension AppTextField {
    func configure(type: AppTextFieldType) {
        textColor = AppConstants.Colors.white
        backgroundColor = .clear
        isOpaque = true

        switch type {
        case .title:
            font = AppConstants.Fonts.bold34
        case .subtitle:
            font = AppConstants.Fonts.regular16
        case .addTaskTitle:
            font = AppConstants.Fonts.regular18
            backgroundColor = AppConstants.Colors.darkGray
            setupPlaceholder(type)
            borderStyle = .roundedRect
        case .addTaskSubtitle:
            font = AppConstants.Fonts.regular18
            backgroundColor = AppConstants.Colors.darkGray
            setupPlaceholder(type)
            layer.cornerRadius = AppConstants.CornerRadius.small
        }

        setupLayout()
    }

    func setupPlaceholder(_ type: AppTextFieldType) {
        let placeholder = type.localizedString
        let attributes: [NSAttributedString.Key: Any] = [
            .font: AppConstants.Fonts.regular16,
            .foregroundColor: AppConstants.Colors.gray
        ]

        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
