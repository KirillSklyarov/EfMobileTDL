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
}
