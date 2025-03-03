//
//  AppStackView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

final class AppStackView: UIStackView {

    public init(_ arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, alignment: Alignment = .fill, distribution: Distribution = .fill, cornerRadius: CGFloat? = nil) {
        super.init(frame: .zero)
        setupUI(arrangedSubviews, spacing: spacing, axis: axis, alignment: alignment, distribution: distribution)
        setCornerRadius(cornerRadius)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppStackView {
    func setupUI(_ arrangedSubviews: [UIView], spacing: CGFloat, axis: NSLayoutConstraint.Axis, alignment: Alignment, distribution: Distribution) {
        arrangedSubviews.forEach { addArrangedSubview($0) }
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }

    func setCornerRadius(_ radius: CGFloat?) {
        if let radius {
            layer.cornerRadius = radius
            layer.masksToBounds = true
        }
    }
}

