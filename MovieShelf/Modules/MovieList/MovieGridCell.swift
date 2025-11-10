//
//  MovieGridCell.swift
//  MovieShelf
//
//  Created by Thalita Auad on 10/11/25.
//

import UIKit

final class MovieGridCell: UICollectionViewCell {
    private let poster = UIImageView()
    private let title = UILabel()
    private let rating = UILabel()
    private let heart = UIButton(type: .system)
    private var currentID: Int?
    private var onToggle: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

        poster.contentMode = .scaleAspectFill; poster.clipsToBounds = true
        title.font = .systemFont(ofSize: 14, weight: .semibold)
        title.numberOfLines = 2
        rating.font = .systemFont(ofSize: 12); rating.textColor = .secondaryLabel
        heart.tintColor = .systemPink

        [poster, title, rating, heart].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: contentView.topAnchor),
            poster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            poster.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),

            title.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 6),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            title.trailingAnchor.constraint(equalTo: heart.leadingAnchor, constant: -6),

            heart.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            heart.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heart.widthAnchor.constraint(equalToConstant: 28),
            heart.heightAnchor.constraint(equalToConstant: 28),

            rating.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            rating.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            rating.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            rating.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])

        heart.addTarget(self, action: #selector(onHeart), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(with vm: MovieCellVM, imageLoader: ImageLoading, onToggle: @escaping (Int) -> Void) {
        currentID = vm.id
        self.onToggle = onToggle
        title.text = vm.title
        rating.text = vm.rating
        poster.image = nil
        setHeart(vm.isFavorite)

        if let url = vm.posterURL {
            imageLoader.load(url: url) { [weak self] img in self?.poster.image = img }
        }
    }

    private func setHeart(_ fav: Bool) {
        let name = fav ? "heart.fill" : "heart"
        heart.setImage(UIImage(systemName: name), for: .normal)
        heart.accessibilityLabel = fav ? "Favorited" : "Not favorited"
    }

    @objc private func onHeart() {
        guard let id = currentID else { return }
        onToggle?(id)
    }
}
