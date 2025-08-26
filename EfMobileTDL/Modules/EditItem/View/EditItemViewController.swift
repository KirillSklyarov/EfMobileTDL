//
//  EditTastVC.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

protocol EditItemViewInput: AnyObject {
    func setupInitialState()
    func showLoading()
    func configure(with task: TDLItem)
    func showError(_ alert: UIAlertController)
}

final class EditItemViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var titleTextField = AppTextField(type: .title)
    private lazy var subtitleTextField = AddTaskSubtitleView()
    private lazy var dateLabel = AppLabel(type: .date)

    private lazy var titleStack = AppStackView([titleTextField, dateLabel], axis: .vertical, spacing: 8)

    private lazy var contentStack = AppStackView([titleStack, subtitleTextField], axis: .vertical, spacing: 16)

    private lazy var activityIndicator = AppActivityIndicator()

    // MARK: - Other properties
    private let output: EditItemViewOutput
    private let textInputHandler: TextInputHandling
    private var navBarStyler: NavigationBarStyler

    // MARK: - Init
    init(output: EditItemViewOutput, navBarStyler: NavigationBarStyler) {
        self.output = output
        self.navBarStyler = navBarStyler
        self.textInputHandler = TextInputHandler(output: output)
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
}

// MARK: - EditTaskViewInput
extension EditItemViewController: EditItemViewInput {
    func setupInitialState() {
        setupUI()
        setupTextFields()
        hideKeyboardWhenTappedAround()
    }

    func showLoading() {
        isShowContent(false)
        activityIndicator.startAnimating()
    }

    func configure(with task: TDLItem) {
        isShowContent(true)
        activityIndicator.stopAnimating()
        updateUI(with: task)
    }

    func showError(_ alert: UIAlertController) {
        activityIndicator.stopAnimating()
        present(alert, animated: true)
    }
}

// MARK: - Setup UI
private extension EditItemViewController {
    func setupUI() {
        navBarStyler.apply(.editTask, to: self)
        navBarStyler.onSaveButtonTapped = { [weak self] in
            self?.output.eventHandler(.saveButtonTapped)
        }

        view.backgroundColor = AppConstants.Colors.black
        view.addSubviews(contentStack, activityIndicator)
        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
        setupActivityIndicatorLayout()
    }

    func setupContentStackLayout() {
        contentStack.setLocalConstraints(
            isSafeArea: true,
            top: AppConstants.Insets.small,
            left: AppConstants.Insets.medium,
            right: AppConstants.Insets.medium
        )
    }

    func setupActivityIndicatorLayout() {
        activityIndicator.setCenterConstraints(on: view)
    }

    func setupTextFields() {
        textInputHandler.bind(to: titleTextField, textView: subtitleTextField)
    }
}


// MARK: - Supporting methods
private extension EditItemViewController {
    func isShowContent(_ isShow: Bool) {
        contentStack.alpha = isShow ? 1 : 0
    }

    func updateUI(with task: TDLItem) {
        titleTextField.text = task.title
        subtitleTextField.setTextViewText(task.subtitle)
        subtitleTextField.setTextViewTextColor(AppConstants.Colors.white)
        dateLabel.text = task.date
    }
}
