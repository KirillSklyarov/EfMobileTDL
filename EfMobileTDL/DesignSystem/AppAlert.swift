//
//  AppAlert.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 06.03.2025.
//

import UIKit

final class AppAlert {
    static func create() -> UIAlertController {
        let alert = UIAlertController(title: "Ошибка загрузки данных", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        return alert
    }
}
