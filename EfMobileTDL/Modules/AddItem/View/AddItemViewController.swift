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

    private lazy var contentStack = AppStackView([titleTextField, subTitleContainer, saveStack, UIView()], axis: .vertical, spacing: 16)

    // MARK: - Other properties
    private let output: AddItemViewOutput
    private let actionBinder: AddItemActionBinding
    private let textInputHandler: TextInputHandler

    // MARK: - Init
    init(output: AddItemViewOutput) {
        self.output = output
        self.actionBinder = AddItemActionBinder(output: output)
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

// MARK: - AddItemViewInput
extension AddItemViewController: AddItemViewInput {
    func setupInitialState() {
        setupUI()
        setupAction()
        setupTextFields()
        hideKeyboardWhenTappedAround()
    }

    func isSaveButtonEnable(_ isEnabled: Bool) {
        saveButton.isSaveButtonEnable(isEnabled)
    }
}

// MARK: - Setup UI
private extension AddItemViewController {
    func setupUI() {
        NavigationBarStyler.apply(.addTask, to: self)
    
        view.backgroundColor = AppConstants.Colors.black

        view.addSubviews(contentStack)
        setupLayout()
    }

    func setupLayout() {
        contentStack.setConstraints(isSafeArea: true, allInsets: AppConstants.Insets.medium)

        NSLayoutConstraint.activate([
            subTitleContainer.heightAnchor.constraint(equalToConstant: AppConstants.Height.subTitleTextView),
            saveButton.widthAnchor.constraint(equalTo: contentStack.widthAnchor, multiplier: 0.5),
        ])
    }

    func setupTextFields() {
        textInputHandler.bind(to: titleTextField, textView: subTitleContainer)
    }

    func setupAction() {
        actionBinder.bind(saveButton: saveButton)
    }
}
