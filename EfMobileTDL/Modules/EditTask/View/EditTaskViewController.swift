//
//  EditTastVC.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

final class EditTaskViewController: UIViewController {

    private lazy var titleTextField = AppTextField(type: .title)
    private lazy var subtitleTextField = AppTextField(type: .subtitle)
    private lazy var dateLabel = AppLabel(type: .date)

    private lazy var titleStack = AppStackView([titleTextField, dateLabel], axis: .vertical, spacing: 8)

    private lazy var subTitleStack = AppStackView([subtitleTextField, UIView()], axis: .vertical, alignment: .leading)

    private lazy var contentStack = AppStackView([titleStack, subTitleStack], axis: .vertical, spacing: 16)

    private var task: Task
    private var index: Int?

    // MARK: - Init
    init(with task: Task) {
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
        navigationController?.navigationBar.prefersLargeTitles = false

        view.backgroundColor = AppConstants.Colors.black
        view.addSubviews(contentStack)
        setupLayout()
    }

    func configure() {
        index = Task.data.firstIndex { $0 == task }

        titleTextField.text = task.title
        subtitleTextField.text = task.subtitle
        dateLabel.text = task.date
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.Insets.small),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.Insets.medium),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.Insets.medium),
            contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func setupTextFields() {
        titleTextField.delegate = self
        subtitleTextField.delegate = self
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

        switch textField {
            case titleTextField:
            if !text.isEmpty {
                task.title = text
            }
        case subtitleTextField:
            if !text.isEmpty {
                task.subtitle = text
            }
        default: break
        }

        print(task)
    }
}


// MARK: - Supporting methods
private extension EditTaskViewController {
    func sendEditedTaskToStorage() {
        guard let index else { print("We can not edit task"); return }
        Task.editTask(task, index: index)
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

