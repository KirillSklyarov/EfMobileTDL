//
//  TextInputHandler.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 26.08.2025.
//

import UIKit

protocol TextInputHandling {
    func bind(to textField: UITextField, textView: AddTaskSubtitleView)
}

final class TextInputHandler: NSObject, TextInputHandling {

    private let output: TextInputProtocol

    init(output: TextInputProtocol) {
        self.output = output
    }

    func bind(to textField: UITextField, textView: AddTaskSubtitleView) {
        textField.delegate = self
        textView.setTextViewDelegate(self)

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let title = textField.text else { Log.app.errorAlways("Title is nil"); return }
        output.handleTitleChange(title: title)
    }
}

// MARK: - UITextFieldDelegate
extension TextInputHandler: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension TextInputHandler: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == AppConstants.Colors.gray {
            textView.text.removeAll()
            textView.textColor = AppConstants.Colors.white
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let subTitle = textView.text else { Log.app.errorAlways("SubTitle is nil"); return }
        output.handleSubTitleChange(subTitle: subTitle)
    }
}
