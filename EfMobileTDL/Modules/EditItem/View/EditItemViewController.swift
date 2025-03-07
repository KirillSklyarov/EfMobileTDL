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
    func showError()
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
    private let output: EditTaskViewOutput

    // MARK: - Init
    init(output: EditTaskViewOutput) {
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output.viewWillDisappear()
    }
}

// MARK: - EditTaskViewInput
extension EditItemViewController: EditItemViewInput {
    func setupInitialState() {
        setupUI()
        setupTextFields()
        setupGestureToDissmissKeyboard()
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

    func showError() {
        activityIndicator.stopAnimating()
        showAlert()
    }

    func showAlert() {
        activityIndicator.stopAnimating()
        let alert = AppAlert.create()
        present(alert, animated: true)
    }
}

// MARK: - Setup UI
private extension EditItemViewController {
    func setupUI() {
        title = "Редактировать задачи"
        navigationController?.navigationBar.prefersLargeTitles = false

        view.backgroundColor = AppConstants.Colors.black
        view.addSubviews(contentStack, activityIndicator)
        setupLayout()
    }

    func setupLayout() {
        setupContentStackLayout()
        setupActivityIndicatorLayout()
    }

    func setupContentStackLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.Insets.small),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.Insets.medium),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.Insets.medium),

            subtitleTextField.heightAnchor.constraint(equalToConstant: AppConstants.Height.textField*5),
        ])
    }

    func setupActivityIndicatorLayout() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    func setupTextFields() {
        titleTextField.delegate = self
        subtitleTextField.setTextViewDelegate(self)

        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

// MARK: - UITextViewDelegate
extension EditItemViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        output.didUpdateTaskSubTitle(text)
    }
}

// MARK: - UITextFieldDelegate
extension EditItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Supporting methods
private extension EditItemViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        output.didUpdateTaskTitle(text)
    }

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

// MARK: - Hide keyboard by tap
private extension EditItemViewController {
    func setupGestureToDissmissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
