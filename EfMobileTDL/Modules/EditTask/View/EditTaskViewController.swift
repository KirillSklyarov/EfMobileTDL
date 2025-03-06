//
//  EditTastVC.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

final class EditTaskViewController: UIViewController {

    private lazy var titleTextField = AppTextField(type: .title)
    private lazy var subtitleTextField = AddTaskSubtitleView()
    private lazy var dateLabel = AppLabel(type: .date)

    private lazy var titleStack = AppStackView([titleTextField, dateLabel], axis: .vertical, spacing: 8)

    private lazy var contentStack = AppStackView([titleStack, subtitleTextField], axis: .vertical, spacing: 16)

    private let storage: AppStorage

    private var task: TDLItem
    private var index: Int?

    // MARK: - Init
    init(with task: TDLItem, storage: AppStorage) {
        self.storage = storage
        self.task = task
        super.init(nibName: nil, bundle: nil)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextFields()
        setupGestureToDissmissKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendEditedTaskToStorage()
    }
}

// MARK: - Setup UI
private extension EditTaskViewController {
    func setupUI() {
        title = "Редактировать задачи"
        navigationController?.navigationBar.prefersLargeTitles = false

        view.backgroundColor = AppConstants.Colors.black
        view.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.Insets.small),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.Insets.medium),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.Insets.medium),

            subtitleTextField.heightAnchor.constraint(equalToConstant: AppConstants.Height.textField*5),
        ])
    }

    func setupTextFields() {
        titleTextField.delegate = self
        subtitleTextField.setTextViewDelegate(self)

        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

// MARK: - UITextViewDelegate
extension EditTaskViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let text = textView.text else { return }
        if !text.isEmpty { task.subtitle = text }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
        if !text.isEmpty { task.subtitle = text }
    }
}

// MARK: - UITextFieldDelegate
extension EditTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text else { return }
        if !text.isEmpty { task.title = text }
    }
}

// MARK: - Supporting methods
private extension EditTaskViewController {
    func sendEditedTaskToStorage() {
        guard let index else { print("We can not edit task"); return }
//        print("Send edited task to storage: \(task)")
//        TaskOld.editTask(task, index: index)
        storage.editTask(task, index: index)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if !text.isEmpty { task.title = text }
//        print("Updated in real time: \(task)")
    }

    func configure() {
        index = storage.data.firstIndex { $0 == task }

        titleTextField.text = task.title
        subtitleTextField.setTextViewText(task.subtitle)
        subtitleTextField.setTextViewTextColor(AppConstants.Colors.white)

        dateLabel.text = task.date
    }

}

// MARK: - Hide keyboard by tap
private extension EditTaskViewController {
    func setupGestureToDissmissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
