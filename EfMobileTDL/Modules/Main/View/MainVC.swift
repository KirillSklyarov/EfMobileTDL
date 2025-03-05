//
//  ViewController.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Properties
    private lazy var searchController = AppSearchController()
    private lazy var tasksTableView = TasksTableView()
    private lazy var footerView = FooterView()
    private lazy var activityIndicator = AppActivityIndicator()

    private let storage: AppStorage
    private var data: [TDL] = []

    // MARK: - Init
    init(storage: AppStorage) {
        self.storage = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        updateData()
        searchController.additionalSearchControllerConfigure()
    }
}

// MARK: - Setup UI
private extension MainViewController {
    func setupUI() {
        setupNavigationBar()
        setupSearchController()

        view.backgroundColor = AppConstants.Colors.black
        view.addSubviews(tasksTableView, footerView, activityIndicator)

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
        setupActivityIndicatorLayout()
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

    func setupActivityIndicatorLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - State management
extension MainViewController {
    func initialSetup() {
        setupUI()
        setupAction()
    }

    func loading() {
        isHideContent(true)
        activityIndicator.startAnimating()
    }

    func configure(with data: [TDL]) {
        self.data = data
        isHideContent(false)
        activityIndicator.stopAnimating()
        tasksTableView.getData(data)
    }

    func error() {
        activityIndicator.stopAnimating()
        showAlert()
    }

    func showAlert() {
        let alert = UIAlertController(title: "Ошибка загрузки данных", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
        print("error")
    }

    func isHideContent(_ isHide: Bool) {
        switch isHide {
        case true:
            tasksTableView.alpha = 0
            footerView.alpha = 0
//            navigationController?.setNavigationBarHidden(true, animated: false)
        case false:
            tasksTableView.alpha = 1
            footerView.alpha = 1
//            navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}

// MARK: - UISearchBarDelegate, UISearchControllerDelegate
extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        tasksTableView.filterData(by: searchText)
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
            guard let self else { return }
            resetSearchController()
            let editVC = EditTaskViewController(with: task, storage: storage)
            navigationController?.pushViewController(editVC, animated: true)
        }

        tasksTableView.onRemoveTask = { [weak self] task in
            guard let self else { return }
            storage.removeTask(task)
        }

        tasksTableView.onChangeTDLState = { [weak self] task in
            guard let self else { return }
            storage.changeTaskState(task)
            updateData()
        }
    }

    func setupAddTaskButtonAction() {
        footerView.onAddTaskButtonTapped = { [weak self] in
            guard let self else { return }
            resetSearchController()
            let addTaskVC = AddTaskViewController(storage: storage)
            navigationController?.pushViewController(addTaskVC, animated: true)
        }
    }

    func resetSearchController() {
        searchController.searchBar.text = ""
    }
}

// MARK: - Supporting methods
private extension MainViewController {
    func updateData() {
        storage.getData { [weak self] data in
            DispatchQueue.main.async {
                self?.data = data
                self?.tasksTableView.getData(data)
            }
        }
    }
}
