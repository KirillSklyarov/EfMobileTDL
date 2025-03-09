//
//  ViewController.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 03.03.2025.
//

import UIKit
import rswift

protocol MainViewInput: AnyObject {
    func setupInitialState()
    func loading()
    func configure(with data: [TDLItem])
    func showError()
    func updateUI(with data: [TDLItem])
}

final class MainViewController: UIViewController {

    // MARK: - Properties
    lazy var searchController = AppSearchController()
    lazy var tasksTableView = TasksTableView()
    lazy var footerView = FooterView()
    lazy var activityIndicator = AppActivityIndicator()

    let output: MainViewOutput

    var isFirstLoad = true

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
        needToUpdateUI()
        setNavBarLargeTitle()
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
        title = AppConstants.L.mainTitle()
        setNavBarLargeTitle()
        
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: R.string.localizable.backButton(), style: .plain, target: nil, action: nil)

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

// MARK: - MainViewInput
extension MainViewController: MainViewInput {
    func setupInitialState() {
        setupUI()
        setupAction()
    }

    func loading() {
        activityIndicator.startAnimating()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            isHideContent(true)
        }
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

    func updateUI(with data: [TDLItem]) {
        UIView.animate(withDuration: 0.3) {
            self.tasksTableView.getData(data)
            self.footerView.updateUI(with: data.count)
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

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        output.viewIsAppearing()
    }
}

// MARK: - Setup action
extension MainViewController {
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
            output.selectItemForEditing(task)
            resetSearchController()
        }

        tasksTableView.onRemoveItem = { [weak self] task in
            guard let self else { return }
            output.removeItemTapped(task)
        }

        tasksTableView.onChangeTDLState = { [weak self] task in
            guard let self else { return }
            output.changeItemState(task)
        }

        tasksTableView.onGetFilteredData = { [weak self] string in
            guard let self else { return }
            output.filterData(by: string)
        }
    }

    func setupAddTaskButtonAction() {
        footerView.onAddTaskButtonTapped = { [weak self] in
            guard let self else { return }
            resetSearchController()
            output.addNewTaskButtonTapped()
        }
    }

    func resetSearchController() {
        searchController.searchBar.text = ""
    }
}

// MARK: - Supporting methods
private extension MainViewController {

    func needToUpdateUI() {
        if !isFirstLoad {
            output.viewIsAppearing()
        } else {
            isFirstLoad = false
        }
    }

    func setNavBarLargeTitle() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func showAlert() {
        let alert = AppAlert.create()
        present(alert, animated: true)
    }

    func isHideContent(_ isHide: Bool) {
        switch isHide {
        case true:
            tasksTableView.alpha = 0
            footerView.alpha = 0
        case false:
            tasksTableView.alpha = 1
            footerView.alpha = 1
        }
    }
}
