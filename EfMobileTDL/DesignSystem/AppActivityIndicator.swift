//
//  AppActivityIndicator.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 05.03.2025.
//

import UIKit

final class AppActivityIndicator: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style = .large) {
        super.init(style: style)
        color = AppConstants.Colors.yellow
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCenterConstraints(on superview: UIView) {
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
}
