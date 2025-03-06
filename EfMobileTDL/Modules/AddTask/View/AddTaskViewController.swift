//
//  AddTaskViewController.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

final class AddTaskViewController: UIViewController {

    private lazy var titleTextField = AppTextField(type: .addTaskTitle)
    private lazy var subTitleContainer = AddTaskSubtitleView()
    private lazy var saveButton = AppButton(style: .save)

    private lazy var saveStack = AppStackView([saveButton], axis: .vertical, alignment: .center)

    private lazy var contentStack = AppStackView([titleTextField, subTitleContainer, saveStack], axis: .vertical, spacing: 16)

    private let interactor: InteractorProtocol
    private let router: AppRouter

    private var task: TDLItem?
    private var textViewText: String?

    // MARK: - Init
    init(interactor: InteractorProtocol, router: AppRouter) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAction()
        setupTextFields()
        setupGestureToDissmissKeyboard()
        checkButton()
    }
}

// MARK: - Setup UI
private extension AddTaskViewController {
    func setupUI() {
        title = "Добавить задачу"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = AppConstants.Colors.black

//        configureDate()

        view.addSubviews(contentStack)
        setupLayout()
    }

//    func configure() {
//        index = Task.data.firstIndex { $0 == task }
//
//        titleTextField.text = task.title
//        subtitleTextField.text = task.subtitle
//        dateLabel.text = task.date
//    }

    func configureDate() -> String {
        let date = Date.now
            .formatted(
                .dateTime
                    .day(.twoDigits)
                    .month(.twoDigits)
                    .year(.twoDigits)
                    .locale(Locale(identifier: "en_GB"))
            )
        return date
//        dateLabel.text = date.description
//        dateLabel.textColor = AppConstants.Colors.white
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
    }
}

private extension AddTaskViewController {
    func setupAction() {
        saveButton.onButtonTapped = { [weak self] in
            guard let self = self else { return }
            configureTask()
            sendNewTaskToStorage()
            router.pop()
        }
    }
}

// MARK: - UITextFieldDelegate
extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        checkButton()
    }
}

// MARK: - UITextViewDelegate
extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == AppConstants.Colors.gray {
            textView.text.removeAll()
            textView.textColor = AppConstants.Colors.white
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        self.textViewText = textView.text
        checkButton()
    }
}


// MARK: - Supporting methods
private extension AddTaskViewController {
    func sendNewTaskToStorage() {
        guard let task else { return }
        interactor.addTask(task)
//        TaskOld.addTask(task)
    }

    func configureTask() {
        guard let title = titleTextField.text,
              let subtitle = textViewText else { print("We have empty fields"); return }
        let date = configureDate()
        let tempID = -UUID().hashValue
        task = TDLItem(id: tempID, title: title, subtitle: subtitle, date: date, completed: false)
    }

    func checkButton() {
        guard let titleText = titleTextField.text,
              let textViewText else { return }
        let isOk = !titleText.isEmpty && !textViewText.isEmpty
        isSaveButtonEnabled(isOk)
    }

    func isSaveButtonEnabled(_ isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
        saveButton.configuration?.background.strokeColor = isEnabled ? AppConstants.Colors.yellow : AppConstants.Colors.gray
    }
}

// MARK: - Hide keyboard by tap
private extension AddTaskViewController {
    func setupGestureToDissmissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - SwiftUI
//import SwiftUI
//struct AddTaskProvider : PreviewProvider {
//    static var previews: some View {
//        ContainterView().edgesIgnoringSafeArea(.all)
//    }
//
//    struct ContainterView: UIViewControllerRepresentable {
//        func makeUIViewController(context: Context) -> UIViewController {
//            return AddTaskViewController()
//        }
//
//        typealias UIViewControllerType = UIViewController
//
//
//        let viewController = AddTaskViewController()
//        func makeUIViewController(context: UIViewControllerRepresentableContext<AddTaskProvider.ContainterView>) -> AddTaskViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: AddTaskProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<AddTaskProvider.ContainterView>) {
//
//        }
//    }
//}
