//
//  KatalogCell.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 05/11/24.
//

import UIKit

class KatalogCell: UITableViewCell {
    private lazy var gameImageView: UIImageView = {
        let imageView: UIImageView = UIImageView(frame: .zero)
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var gameNameLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private lazy var releasedLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func editDataView(game: KatalogGameModel) {
        gameNameLabel.text = game.name
        ratingLabel.text = "Game Rating: "
        releasedLabel.text = "Released: "
        gameImageView.load(url: URL(string: game.image ?? ""),
                           placeholder: UIImage(systemName: "circle.dashed"))
        if let released = game.released {
            releasedLabel.text?.append(released)
        } else {
            releasedLabel.text = "No Release Date"
        }

        ratingLabel.text?.append(String(game.rating))
    }

    static func getSizeDataView() -> CGFloat {
        return 132
    }
}

private extension KatalogCell {
    func setupUI() {
        contentView.addSubview(gameImageView)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(releasedLabel)
        contentView.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            gameImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gameImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            gameNameLabel.topAnchor.constraint(equalTo: gameImageView.topAnchor),
            gameNameLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 8),
            gameNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            releasedLabel.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 4),
            releasedLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            releasedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            ratingLabel.topAnchor.constraint(equalTo: releasedLabel.bottomAnchor, constant: 4),
            ratingLabel.leadingAnchor.constraint(equalTo: gameNameLabel.leadingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: gameImageView.bottomAnchor)
        ])
    }
}
