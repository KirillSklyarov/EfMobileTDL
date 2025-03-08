//
//  AppConstants.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit
import rswift

struct AppConstants {

    static let L = R.string.localizable

    enum SystemImages {
        static let edit = UIImage(systemName: "square.and.pencil")
        static let share = UIImage(systemName: "square.and.arrow.up")
        static let delete = UIImage(systemName: "trash")
        static let microphone = UIImage(systemName: "microphone.fill")
        static let taskCompleted = UIImage(systemName: "checkmark.circle")
        static let taskNotCompleted = UIImage(systemName: "circle")
    }

    enum Colors {
        static let black = UIColor(hex: "040404")
        static let white = UIColor(hex: "F4F4F4")
        static let gray = UIColor(hex: "4D555E")
        static let darkGray = UIColor(hex: "272729")
        static let yellow = UIColor(hex: "FED702")
    }

    enum Insets {
        static let small: CGFloat = 5
        static let medium: CGFloat = 20
    }

    enum Fonts {
        static let regular11: UIFont = .systemFont(ofSize: 11, weight: .regular)
        static let regular12: UIFont = .systemFont(ofSize: 12, weight: .regular)
        static let regular16: UIFont = .systemFont(ofSize: 16, weight: .regular)
        static let regular18: UIFont = .systemFont(ofSize: 16, weight: .regular)


        static let bold34: UIFont = .systemFont(ofSize: 34, weight: .bold)
    }

    enum Height {
        static let textField: CGFloat = 50
    }
}
