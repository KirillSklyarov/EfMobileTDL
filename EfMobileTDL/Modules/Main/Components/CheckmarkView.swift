//
//  CheckmarkView.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 04.03.2025.
//

import UIKit

final class CheckmarkView: UIView {

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
        let checkImageView = configureImageView()
        addSubviews(checkImageView)
        widthAnchor.constraint(equalToConstant: 24).isActive = true
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
