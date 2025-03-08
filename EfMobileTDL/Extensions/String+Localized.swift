//
//  String+Localized.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 08.03.2025.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(withComment comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
