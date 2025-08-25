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
    case editTitle
    case footerLabel
}

final class AppLabel: UILabel {

    // MARK: - Init
    init(type: AppLabelType, numberOfLines: Int = 0) {
        super.init(frame: .zero)
        configure(type, numberOfLines: numberOfLines)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
private extension AppLabel {
    func configure(_ type: AppLabelType, numberOfLines: Int) {
        switch type {
        case .title:
            font = AppConstants.Fonts.regular16
            textColor = AppConstants.Colors.white
            self.numberOfLines = 0
        case .subtitle:
            font = AppConstants.Fonts.regular12
            textColor = AppConstants.Colors.white
            self.numberOfLines = numberOfLines
        case .date:
            font = AppConstants.Fonts.regular12
            textColor = AppConstants.Colors.gray
            self.numberOfLines = 0
        case .editTitle:
            font = AppConstants.Fonts.bold34
            textColor = AppConstants.Colors.white
            self.numberOfLines = 0
        case .footerLabel:
            textColor = .white
            textAlignment = .center
            font = AppConstants.Fonts.regular12
        }
    }
}
