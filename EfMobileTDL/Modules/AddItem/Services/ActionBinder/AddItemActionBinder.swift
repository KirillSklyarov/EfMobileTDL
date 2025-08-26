//
//  AddItemActionBinder.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 26.08.2025.
//

import UIKit

protocol AddItemActionBinding {
    func bind(saveButton: AppButton)
}

final class AddItemActionBinder: AddItemActionBinding {

    private let output: AddItemViewOutput

    init(output: AddItemViewOutput) {
        self.output = output
    }

    func bind(saveButton: AppButton) {
        saveButton.onButtonTapped = { [weak self] in
            guard let self = self else { return }
            output.eventHandler(.saveButtonTapped)
        }
    }
}
