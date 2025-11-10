//
//  MovieDetailViewController.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit

final class MovieDetailViewController: UIViewController, MovieDetailViewInput {
    var presenter: MovieDetailViewOutput?
    private var deps: Deps?

    static func make(movieID: Int, deps: Deps) -> UIViewController {
        let vc = MovieDetailViewController()
        vc.deps = deps
        let interactor = MovieDetailInteractor(api: deps.api, favs: deps.favs, movieID: movieID)
        let router = MovieDetailRouter(deps: deps)
        router.viewController = vc
        let presenter = MovieDetailPresenter(view: vc, interactor: interactor, router: router)
        vc.presenter = presenter
        interactor.output = presenter
        return vc
    }

    private let scroll = UIScrollView()
    private let backdrop = UIImageView()
    private let titleLabel = UILabel()
    private let subtitle = UILabel()
    private let overview = UILabel()
    private let info = UILabel()
    private let saveButton = UIButton(type: .system)
    private let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Details"
        setupUI()
        presenter?.viewDidLoad()
    }

    private func setupUI() {
        backdrop.contentMode = .scaleAspectFill
        backdrop.clipsToBounds = true
        titleLabel.font = .boldSystemFont(ofSize: 22)
        subtitle.textColor = .secondaryLabel
        overview.numberOfLines = 0
        info.numberOfLines = 0
        saveButton.setTitle("Save locally", for: .normal)
        saveButton.addTarget(self, action: #selector(onSave), for: .touchUpInside)

        scroll.translatesAutoresizingMaskIntoConstraints = false
        [backdrop, titleLabel, subtitle, overview, info, saveButton, spinner].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        view.addSubview(scroll)
        view.addSubview(spinner)
        [backdrop, titleLabel, subtitle, overview, info, saveButton].forEach { scroll.addSubview($0) }

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: guide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

            backdrop.topAnchor.constraint(equalTo: scroll.topAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backdrop.heightAnchor.constraint(equalToConstant: 180),

            titleLabel.topAnchor.constraint(equalTo: backdrop.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            subtitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitle.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitle.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            overview.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 12),
            overview.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overview.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            info.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 12),
            info.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            info.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            saveButton.topAnchor.constraint(equalTo: info.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -24),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc private func onSave() {
        presenter?.didTapSave()
    }

    // MARK: - ViewInput
    func askNavigateToFavorites(saved: Bool, onConfirm: @escaping () -> Void) {
        let title = saved ? "Saved ✓" : "Removed"
        let alert = UIAlertController(
            title: title,
            message: "Do you want to open your Favorites now?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            onConfirm()
        }))
        present(alert, animated: true)
    }
    
    func showLoading(_ on: Bool) { on ? spinner.startAnimating() : spinner.stopAnimating() }
    
    func show(details: MovieDetails) {
        titleLabel.text = details.originalTitle
        subtitle.text = details.title
        overview.text = details.overview ?? "—"
        info.text =
        """
        Release: \(details.releaseDate ?? "—")
        Budget: $\(details.budget ?? 0)
        Revenue: $\(details.revenue ?? 0)
        Vote: \(String(format: "%.1f", details.voteAverage)) ★
        """
        if let path = details.backdropPath,
           let url = URL(string: "https://image.tmdb.org/t/p/w780\(path)") {
            deps?.imageLoader.load(url: url) { [weak self] img in self?.backdrop.image = img }
        }
    }
    
    func setSaved(_ saved: Bool) {
        saveButton.setTitle(saved ? "Saved ✓" : "Save locally", for: .normal)
    }
    
    func showError(_ message: String) {
        let a = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}
