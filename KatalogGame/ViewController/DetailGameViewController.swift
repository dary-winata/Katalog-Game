//
//  DetailGameViewController.swift
//  KatalogGame
//
//  Created by dary winata nugraha djati on 10/11/24.
//

import UIKit

class DetailGameViewController: UIViewController {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 32) / 2).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private lazy var gameDescriptionLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var detailStack: UIStackView = {
        let stackView: UIStackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private lazy var releasedLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()
    
    private lazy var spinnerLoading: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false

        return spinner
    }()

    let viewModel: DetailGameViewModelProtocol

    init(viewModel: DetailGameViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
    }
    
    func addLoadingView() {
        spinnerLoading.startAnimating()
        spinnerLoading.isHidden = false
    }
    
    func stopLoadingView() {
        spinnerLoading.isHidden = true
    }
}

extension DetailGameViewController: DetailGameViewModelDelegate {
    func setupView() {
        self.view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        view.addSubview(spinnerLoading)

        NSLayoutConstraint.activate([
            spinnerLoading.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            spinnerLoading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        scrollView.addSubview(imageView)
        scrollView.addSubview(detailStack)
        scrollView.addSubview(gameDescriptionLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),

            detailStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            detailStack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            gameDescriptionLabel.topAnchor.constraint(equalTo: detailStack.bottomAnchor, constant: 10),
            gameDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            gameDescriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            gameDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        detailStack.addArrangedSubview(releasedLabel)
        detailStack.addArrangedSubview(ratingLabel)
    }
    
    func updateView(game: DetailGameModel) {
        self.title = game.name
        releasedLabel.text = "released: \(game.released ?? "TBA")"
        ratingLabel.text = "rating: \(String(game.rating ?? 0.0))"
        imageView.load(url: URL(string: game.image ?? ""),
                       placeholder: UIImage(systemName: "circle.dashed"))
        gameDescriptionLabel.text = game.description
        
        self.view.layoutIfNeeded()
    }
    
    func updateFavoriteNavigationBar(isFavorite: Bool) {
        if isFavorite {
            let favoriteButton =
            UIBarButtonItem(image: UIImage(systemName: "heart.fill"),
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(onFavoriteButtonDidTapped))
            navigationItem.rightBarButtonItem = favoriteButton
        } else {
            let favoriteButton =
            UIBarButtonItem(image: UIImage(systemName: "heart"),
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(onFavoriteButtonDidTapped))
            navigationItem.rightBarButtonItem = favoriteButton
        }
    }
}

private extension DetailGameViewController {
    @objc
    func onFavoriteButtonDidTapped() {
        viewModel.onFavoriteButtonDidTapped()
    }
    
    func setupLoadingView() {
        spinnerLoading.frame = CGRect(x: CGFloat(0),
                                      y: CGFloat(0),
                                      width: view.bounds.width,
                                      height: CGFloat(44))
    }
}
