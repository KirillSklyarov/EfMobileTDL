//
//  AppTextField.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

enum AppTextFieldType {
    case title
    case subtitle
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
        }

        setupLayout()
    }

    func setupLayout() {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
