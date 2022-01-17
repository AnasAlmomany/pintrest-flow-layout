//
//  PhotoItemCell.swift
//  New Collection design
//
//  Created by Anas Almomany on 17/01/2022.
//

import Foundation
import Kingfisher

class PhotoItemCell: UICollectionViewCell {
    static let reuseIdentifer = "photo-item"
    let imageView = UIImageView()
    let contentContainer = UIView()

    var photoURL: String? {
        didSet {
            configure()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        contentContainer.layer.cornerRadius = 5
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentContainer)

        guard let url = photoURL else { return }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: url))
        imageView.contentMode = .scaleAspectFill

        contentContainer.clipsToBounds = true
        contentContainer.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(imageView)

        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: contentContainer.topAnchor)
        ])
    }
}
