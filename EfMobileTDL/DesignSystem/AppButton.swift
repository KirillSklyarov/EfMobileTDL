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
        let image: UIImage?

        switch style {
        case .micro:
            image = UIImage(systemName: "microphone.fill")
            tintColor = AppConstants.Colors.gray
            contentMode = .scaleAspectFit
        case .addTask:
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            image = UIImage(systemName: "square.and.pencil", withConfiguration: config)?
                .withTintColor(AppConstants.Colors.yellow)
                .withRenderingMode(.alwaysOriginal)
        }

        setImage(image, for: .normal)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc func buttonTapped() {
        onButtonTapped?()
    }
}
