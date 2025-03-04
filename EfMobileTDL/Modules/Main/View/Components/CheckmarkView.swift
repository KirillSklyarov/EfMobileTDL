//
//  CheckmarkView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

final class CheckmarkView: UIView {

    private lazy var checkImageView = configureImageView()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure
private extension CheckmarkView {
    func configure() {
        addSubviews(checkImageView)
        setupLayout()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 24),
            checkImageView.topAnchor.constraint(equalTo: topAnchor),
            checkImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func configureImageView() -> UIImageView {
        let image = UIImage(systemName: "circle")?
            .withTintColor(AppConstants.Colors.gray)
            .withRenderingMode(.alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }
}
