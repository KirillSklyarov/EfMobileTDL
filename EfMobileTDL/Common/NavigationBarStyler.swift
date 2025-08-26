//
//  NavigationBarStyler.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 25.08.2025.
//

import UIKit

enum NavBarStyle {
    case main
    case editTask
    case addTask
}

struct NavigationBarStyler {
    static func appearance() -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = AppConstants.Colors.black
            appearance.largeTitleTextAttributes = [.foregroundColor: AppConstants.Colors.white]
            appearance.titleTextAttributes = [.foregroundColor: AppConstants.Colors.white]
            appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: AppConstants.Colors.yellow]
            return appearance
        }

    static func apply(_ style: NavBarStyle, to vc: UIViewController, searchController: UISearchController) {
        let appearance = appearance()
        vc.navigationController?.navigationBar.standardAppearance = appearance
        vc.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        vc.navigationController?.navigationBar.compactAppearance = appearance
        vc.navigationController?.navigationBar.tintColor = AppConstants.Colors.yellow

        vc.navigationItem.hidesSearchBarWhenScrolling = false
        vc.navigationItem.backBarButtonItem = UIBarButtonItem(
            title: AppConstants.L.backButton(),
            style: .plain, target: nil, action: nil
        )

        vc.navigationItem.searchController = searchController


        switch style {
        case .main:
            vc.title = AppConstants.L.mainTitle()
            vc.navigationController?.navigationBar.prefersLargeTitles = true
        case .editTask, .addTask:
            vc.navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    static func setNavBarLargeTitle(to vc: UIViewController) {
        vc.navigationController?.navigationBar.prefersLargeTitles = true
    }

    static func hideNavBar(_ isHide: Bool, vc: UIViewController) {
        vc.title = isHide ? "" : AppConstants.L.mainTitle()
    }
}
