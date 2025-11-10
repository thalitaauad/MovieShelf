//
//  MovieListViewController.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit

final class MovieListViewController: UIViewController, MovieListViewInput {

    private let deps: Deps
    var presenter: MovieListViewOutput?

    init(deps: Deps) {
        self.deps = deps
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func make(initialQuery: String, deps: Deps) -> UIViewController {
        let vc = MovieListViewController(deps: deps)
        let interactor = MovieListInteractor(api: deps.api, favs: deps.favs, initialQuery: initialQuery)
        let router = MovieListRouter(deps: deps); router.viewController = vc
        let presenter = MovieListPresenter(view: vc, interactor: interactor, router: router)
        vc.presenter = presenter
        interactor.output = presenter
        return vc
    }

    // MARK: - State
    private var items: [MovieCellVM] = []

    // MARK: - UI
    private lazy var collection: UICollectionView = {
        let spacing: CGFloat = 12
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let width = (view.bounds.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.7)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.dataSource = self
        cv.delegate = self
        cv.register(MovieGridCell.self, forCellWithReuseIdentifier: "grid")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    private let spinner = UIActivityIndicatorView(style: .large)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        view.backgroundColor = .systemBackground

        view.addSubview(collection)
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewDidLoad()
    }

    // MARK: - ViewInput
    func showLoading(_ on: Bool) {
        on ? spinner.startAnimating() : spinner.stopAnimating()
    }

    func show(items: [MovieCellVM]) {
        self.items = items
        collection.reloadData()
    }

    func showError(_ message: String) {
        let a = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}

// MARK: - UICollectionViewDataSource/Delegate
extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vm = items[indexPath.item]

        guard let cell = cv.dequeueReusableCell(withReuseIdentifier: "grid", for: indexPath) as? MovieGridCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: vm, imageLoader: deps.imageLoader) { [weak self] id in
            self?.presenter?.didToggleFavorite(id: id)
        }
        return cell
    }

    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelect(id: items[indexPath.item].id)
    }
}
