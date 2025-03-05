//
//  CheckmarkView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

final class CheckmarkView: UIView {

    private lazy var checkButton = AppButton(style: .taskPoint)
    var onDoneButtonTapped: ((Bool) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
extension CheckmarkView {
    func setState(_ state: Bool) {
        checkButton.isSelected = state
    }
}

// MARK: - Configure
private extension CheckmarkView {
    func configure() {
        contentMode = .scaleAspectFit
        addSubviews(checkButton)
        setupLayout()
    }

    func setupLayout() {
        widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
}

// MARK: - Setup action
private extension CheckmarkView {
    func setupAction() {
        checkButton.onButtonTapped = { [weak self] in
            guard let self else { return }
            checkButton.isSelected.toggle()
            onDoneButtonTapped?(checkButton.isSelected)
        }
    }
}
