//
//  AppAlert.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import UIKit

enum AlertType {
    case loadingError
    case editTaskError
}

final class AppAlert {
    static func create(_ type: AlertType) -> UIAlertController {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        switch type {

        case .loadingError:
            alert.title = AppConstants.L.loadingError()
        case .editTaskError:
            alert.title = AppConstants.L.invalidData()
            alert.message = "Check task data.\nTitle and description can't be empty."
        }

        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alert
    }
}
