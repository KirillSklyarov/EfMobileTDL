//
//  AppConstants.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

struct AppConstants {

    enum Colors {
        static let black = UIColor(hex: "040404")
        static let white = UIColor(hex: "F4F4F4")
        static let gray = UIColor(hex: "4D555E")
        static let darkGray = UIColor(hex: "272729")
        static let yellow = UIColor(hex: "FED702")
    }

    enum Insets {
        static let small: CGFloat = 12
        static let medium: CGFloat = 20
    }

    enum Fonts {
        static let regular11: UIFont = .systemFont(ofSize: 11, weight: .regular)
        static let regular12: UIFont = .systemFont(ofSize: 12, weight: .regular)
        static let regular16: UIFont = .systemFont(ofSize: 16, weight: .regular)


    }
}
