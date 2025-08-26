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
    func showError(_ alert: UIAlertController)
    
    func resetSearchController()
}

final class MainViewController: UIViewController {

    // MARK: - Properties
    private lazy var searchController = AppSearchController()
    private lazy var tasksTableView = TasksTableView()
    private lazy var footerView = FooterView()
    private lazy var activityIndicator = AppActivityIndicator()

    private let output: MainViewOutput
    private let searchHandler: SearchHandling
    private let mainActionBinder: MainActionBinding

    // MARK: - Init
    init(output: MainViewOutput) {
        self.output = output
        self.searchHandler = SearchHandler(output: output)
        self.mainActionBinder = MainActionBinder(output: output)
        super.init(nibName: nil, bundle: nil)
        mainActionBinder.setVC(self)
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
        setupSearchHandler()
        setupNavigationBar()

        view.backgroundColor = AppConstants.Colors.black
        view.addSubviews(tasksTableView, footerView, activityIndicator)

        setupLayout()
    }

    func setupNavigationBar() {
        NavigationBarStyler.apply(.main, to: self, searchController: searchController)
    }

    func setupSearchHandler() {
        searchHandler.bind(to: searchController)
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
            footerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
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
        setupActions()
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

    func showError(_ alert: UIAlertController) {
        activityIndicator.stopAnimating()
        present(alert, animated: true)

    }

    func resetSearchController() {
        searchHandler.reset(searchController)
    }
}

// MARK: - Supporting methods
private extension MainViewController {
    func setupActions() {
        mainActionBinder.bind(tasksTableView: tasksTableView, footerView: footerView)
    }

    func updateUI(with data: [TDLItem]) {
        tasksTableView.apply(tasks: data)
        footerView.updateUI(with: data.count)
    }

    func isHideContent(_ isHide: Bool) {
        NavigationBarStyler.hideNavBar(isHide, vc: self)
        searchController.hide(isHide)

        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.tasksTableView.alpha = isHide ? 0 : 1
            self?.footerView.alpha = isHide ? 0 : 1
        }
    }
}
