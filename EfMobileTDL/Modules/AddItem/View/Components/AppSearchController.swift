//
//  AppSearchController.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

final class AppSearchController: UISearchController {

    override init(searchResultsController: UIViewController? = nil) {
        super.init(searchResultsController: searchResultsController)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func additionalSearchControllerConfigure() {
        if searchBar.searchTextField.rightView == nil {
            let button = AppButton(style: .micro)
            searchBar.searchTextField.rightView = button
            searchBar.searchTextField.rightViewMode = .unlessEditing
            searchBar.searchTextField.textColor = .white
        }
    }
}

private extension AppSearchController {
    func configure() {
        let searchTextField = searchBar.searchTextField
        searchTextField.backgroundColor = AppConstants.Colors.darkGray
        searchTextField.leftView?.tintColor = AppConstants.Colors.gray
        searchTextField.attributedPlaceholder = NSAttributedString(string: "search".localized, attributes: [.foregroundColor: AppConstants.Colors.gray])

        hidesNavigationBarDuringPresentation = true
    }
}

