//
//  ViewController.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit

protocol MainViewInput: AnyObject {
    func setupInitialState()
    func loading()
    func configure(with data: [TDLItem])
    func showError()

    func resetSearchController()
}

final class MainViewController: UIViewController {

    // MARK: - Properties
    private lazy var searchController = AppSearchController()
    private lazy var tasksTableView = TasksTableView()
    private lazy var footerView = FooterView()
    private lazy var activityIndicator = AppActivityIndicator()

    private let output: MainViewOutput

    // MARK: - Init
    init(output: MainViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewLoaded()
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        output.appearingUpdateUI()
        appearingUpdateUI()
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
        NavigationBarStyler.apply(.main, to: self, searchController: searchController)
    }

    func appearingUpdateUI() {
        NavigationBarStyler.setNavBarLargeTitle(to: self)
        searchController.additionalSearchControllerConfigure()
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

// MARK: - MainViewInput
extension MainViewController: MainViewInput {
    func setupInitialState() {
        setupUI()
        setupAction()
    }

    func loading() {
        activityIndicator.startAnimating()
        isHideContent(true)
    }

    func configure(with data: [TDLItem]) {
        isHideContent(false)
        activityIndicator.stopAnimating()
        updateUI(with: data)
    }

    func showError() {
        activityIndicator.stopAnimating()
        showAlert()
    }

    func resetSearchController() {
        searchController.searchBar.text = ""
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
        output.eventHandler(.filterData(by: searchText))
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.eventHandler(.cancelSearch)
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
            output.eventHandler(.editTask(task))
        }

        tasksTableView.onRemoveItem = { [weak self] task in
            guard let self else { return }
            output.eventHandler(.deleteItem(task))
        }

        tasksTableView.onChangeTDLState = { [weak self] task in
            guard let self else { return }
            output.eventHandler(.changeItemState(task))
        }
    }

    func setupAddTaskButtonAction() {
        footerView.onAddTaskButtonTapped = { [weak self] in
            guard let self else { return }
            output.eventHandler(.addNewTask)
        }
    }
}

// MARK: - Supporting methods
private extension MainViewController {
    func updateUI(with data: [TDLItem]) {
        DispatchQueue.main.async { [weak self] in
            self?.tasksTableView.apply(tasks: data)
            self?.footerView.updateUI(with: data.count)
        }
    }

    func showAlert() {
        let alert = AppAlert.create()
        present(alert, animated: true)
    }

    func isHideContent(_ isHide: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tasksTableView.alpha = isHide ? 0 : 1
            self?.footerView.alpha = isHide ? 0 : 1
        }
    }
}
