//
//  ViewController.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

final class MainViewController: UIViewController {

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        let searchTextField = controller.searchBar.searchTextField
        searchTextField.backgroundColor = AppConstants.Colors.darkGray
        searchTextField.leftView?.tintColor = AppConstants.Colors.gray

        searchTextField.rightView = AppButton(style: .micro)
        searchTextField.rightViewMode = .unlessEditing

        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.foregroundColor: AppConstants.Colors.gray])

        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.delegate = self
        return controller
    }()

    private lazy var tasksTableView = TasksTableView()
    private lazy var footerView = FooterView()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tasksTableView.loadDataFromStorage()
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

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppConstants.Colors.black
        appearance.largeTitleTextAttributes = [.foregroundColor: AppConstants.Colors.white]
        appearance.titleTextAttributes = [.foregroundColor: AppConstants.Colors.white]
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: AppConstants.Colors.yellow]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = AppConstants.Colors.yellow
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)

        navigationItem.hidesSearchBarWhenScrolling = false

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
        searchTextField.rightView = AppButton(style: .micro)
        searchTextField.rightViewMode = .unlessEditing
    }
}

// MARK: - Setup action
private extension MainViewController {
    func setupAction() {
        setupTasksTableViewAction()
        setupAddTaskButtonAction()
    }

    func setupTasksTableViewAction() {
        tasksTableView.onShowShareScreen = { [weak self] activityVC in
            self?.present(activityVC, animated: true)
        }

        tasksTableView.onEditScreen = { [weak self] task in
            let editVC = EditTaskViewController(with: task)
            self?.navigationController?.pushViewController(editVC, animated: true)
        }
    }

    func setupAddTaskButtonAction() {
        footerView.onAddTaskButtonTapped = { [weak self] in
            let addTaskVC = AddTaskViewController()
            self?.navigationController?.pushViewController(addTaskVC, animated: true)
        }
    }
}
