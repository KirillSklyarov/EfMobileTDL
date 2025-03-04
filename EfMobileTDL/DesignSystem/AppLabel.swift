//
//  AppLabel.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

enum AppLabelType {
    case title
    case subtitle
    case date
}

final class AppLabel: UILabel {

    // MARK: - Init
    init(type: AppLabelType) {
        super.init(frame: .zero)
        configure(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppLabel {
    func configure(_ type: AppLabelType) {
        switch type {
        case .title:
            font = AppConstants.Fonts.regular16
            textColor = AppConstants.Colors.white
        case .subtitle:
            font = AppConstants.Fonts.regular12
            textColor = AppConstants.Colors.white
            numberOfLines = 2
        case .date:
            font = AppConstants.Fonts.regular12
            textColor = AppConstants.Colors.gray
        }
    }
}
