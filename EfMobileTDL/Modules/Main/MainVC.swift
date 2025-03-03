//
//  ViewController.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

final class MainViewController: UIViewController {

    private lazy var searchController = UISearchController(searchResultsController: nil)
    private lazy var tasksTableView = TasksTableView()
    private lazy var footerView = FooterView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSearchController()
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        setupNavigationBar()
        view.backgroundColor = AppConstants.Colors.black
        view.addSubviews(tasksTableView, footerView)

        setupLayout()
    }

    func setupNavigationBar() {
        title = "Задачи"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: AppConstants.Colors.white]
        navigationItem.searchController = searchController
    }
}

// MARK: - Setup layout
private extension MainViewController {
    func setupLayout() {
        setupTableViewLayout()
        setupFooterViewLayout()
    }

    func setupFooterViewLayout() {
        NSLayoutConstraint.activate([
            footerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 83/800),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupTableViewLayout() {
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.Insets.medium),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.Insets.medium),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.Insets.medium),
            tasksTableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
    }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func setupSearchController() {
        let searchTextField = searchController.searchBar.searchTextField
        searchTextField.backgroundColor = AppConstants.Colors.darkGray
        searchTextField.leftView?.tintColor = AppConstants.Colors.gray

        searchTextField.rightView = AppButton(style: .micro)
        searchTextField.rightViewMode = .unlessEditing

        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: AppConstants.Colors.gray])

        searchController.searchBar.delegate = self
    }
}

private extension MainViewController {
    func setupAction() {

    }
}
