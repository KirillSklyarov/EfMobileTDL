//
//  UIView+Ext.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setBorder(_ color: UIColor = .systemRed, borderWidth: CGFloat = 2) {
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
    }


    // Делаем констреинты (если нужно учитываем safeArea, если все отступы равны, то указываем только allInset, если нужны указать разные отступы, то пишем insets)
    func setConstraints(isSafeArea: Bool = false, allInsets: CGFloat? = nil, insets: UIEdgeInsets = .zero) {
        guard let superview else { return }
        let topConstraints = isSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let bottomConstraints = isSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
        let appliedInset = (allInsets != nil) ? UIEdgeInsets(top: allInsets!, left: allInsets!, bottom: allInsets!, right: allInsets!) : insets

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: appliedInset.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -appliedInset.right),
            topAnchor.constraint(equalTo: topConstraints, constant: appliedInset.top),
            bottomAnchor.constraint(equalTo: bottomConstraints, constant: -appliedInset.bottom)
        ])
    }

    func setLocalConstraints(isSafeArea: Bool = false, top: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil) {
        guard let superview else { return }
        let topConstraints = isSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
        let bottomConstraints = isSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor

        if let top {
            topAnchor.constraint(equalTo: topConstraints, constant: top).isActive = true
        }

        if let bottom {
            bottomAnchor.constraint(equalTo: bottomConstraints, constant: -bottom).isActive = true
        }

        if let left {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left).isActive = true
        }

        if let right {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -right).isActive = true
        }
    }
}
