//
//  AddTaskViewController.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

protocol AddItemViewInput: AnyObject {
    func setupInitialState()
    func isSaveButtonEnable(_ isEnabled: Bool)
}

final class AddItemViewController: UIViewController {

    // MARK: - UI Properties
    private lazy var titleTextField = AppTextField(type: .addTaskTitle)
    private lazy var subTitleContainer = AddTaskSubtitleView()
    private lazy var saveButton = AppButton(style: .save)

    private lazy var saveStack = AppStackView([saveButton], axis: .vertical, alignment: .center)

    private lazy var contentStack = AppStackView([titleTextField, subTitleContainer, saveStack], axis: .vertical, spacing: 16)

    // MARK: - Other properties
    private let output: AddItemViewOutput

    // MARK: - Init
    init(output: AddItemViewOutput) {
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
}

// MARK: - AddItemViewInput
extension AddItemViewController: AddItemViewInput {
    func setupInitialState() {
        setupUI()
        setupAction()
        setupTextFields()
        setupGestureToDissmissKeyboard()
    }

    func isSaveButtonEnable(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.configuration?.background.strokeColor = isEnabled ? AppConstants.Colors.yellow : AppConstants.Colors.gray
    }
}

// MARK: - Setup UI
private extension AddItemViewController {
    func setupUI() {
        title = "addTask".localized
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = AppConstants.Colors.black

        view.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.Insets.medium),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppConstants.Insets.medium),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.Insets.medium),

            subTitleContainer.heightAnchor.constraint(equalToConstant: AppConstants.Height.textField*5),
            saveButton.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.5),
        ])
    }

    func setupTextFields() {
        titleTextField.delegate = self
        subTitleContainer.setTextViewDelegate(self)

        titleTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

private extension AddItemViewController {
    func setupAction() {
        saveButton.onButtonTapped = { [weak self] in
            guard let self = self else { return }
            output.sendButtonTapped()
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        output.addedItemTitle(text)
    }
}

// MARK: - UITextViewDelegate
extension AddItemViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == AppConstants.Colors.gray {
            textView.text.removeAll()
            textView.textColor = AppConstants.Colors.white
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        output.addedItemSubtitle(textView.text)
    }
}

// MARK: - Hide keyboard by tap
private extension AddItemViewController {
    func setupGestureToDissmissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
