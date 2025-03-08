//
//  AppButton.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

enum AppButtonStyle {
    case micro
    case addTask
    case save
    case taskPoint
}

final class AppButton: UIButton {

    var onButtonTapped: (() -> Void)?

    init(style: AppButtonStyle) {
        super.init(frame: .zero)
        configure(style)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppButton {
    func configure(_ style: AppButtonStyle) {
        switch style {
        case .micro:
            let image = UIImage(systemName: "microphone.fill")
            tintColor = AppConstants.Colors.gray
            contentMode = .scaleAspectFit
            setImage(image, for: .normal)
        case .addTask:
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            let image = UIImage(systemName: "square.and.pencil", withConfiguration: config)?
                .withTintColor(AppConstants.Colors.yellow)
                .withRenderingMode(.alwaysOriginal)
            setImage(image, for: .normal)

        case .save: setupSaveButton()
        case .taskPoint:
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            let image = UIImage(systemName: "circle", withConfiguration: config)?
                .withTintColor(AppConstants.Colors.gray)
                .withRenderingMode(.alwaysOriginal)
            let selectedImage = UIImage(systemName: "checkmark.circle", withConfiguration: config)?
                .withTintColor(AppConstants.Colors.yellow)
                .withRenderingMode(.alwaysOriginal)
            setImage(image, for: .normal)
            setImage(selectedImage, for: .selected)
        }
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        onButtonTapped?()
    }

    func setupSaveButton(type: AppButtonStyle = .save) {
        var config = UIButton.Configuration.plain()
        config.title = "save".localized
        config.baseForegroundColor = AppConstants.Colors.yellow
        config.baseBackgroundColor = .systemBackground
        config.cornerStyle = .capsule
        config.background.strokeWidth = 1
        isEnabled = false
        config.background.strokeColor = AppConstants.Colors.gray
        configuration = config
    }
}
