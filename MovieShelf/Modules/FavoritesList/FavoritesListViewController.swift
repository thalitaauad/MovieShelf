//
//  FavoritesListViewController.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit

final class FavoritesListViewController: UIViewController, FavoritesListViewInput {
    var presenter: FavoritesListViewOutput?
    private var items: [FavoriteCellVM] = []

    static func make(deps: Deps) -> UIViewController {
        let vc = FavoritesListViewController()
        let interactor = FavoritesListInteractor(favs: deps.favs)
        let router = FavoritesListRouter(deps: deps); router.viewController = vc
        let presenter = FavoritesListPresenter(view: vc, interactor: interactor, router: router)
        vc.presenter = presenter; interactor.output = presenter
        return vc
    }

    // UI
    private let table = UITableView()
    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "No favorites yet"
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"; view.backgroundColor = .systemBackground
        table.dataSource = self; table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(table); view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    // MARK: ViewInput
    func show(items: [FavoriteCellVM]) { self.items = items; table.reloadData() }
    func showEmpty(_ on: Bool) { emptyLabel.isHidden = !on; table.isHidden = on }
}

extension FavoritesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = items[indexPath.row]
        let c = tv.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var conf = c.defaultContentConfiguration()
        conf.text = vm.title
        conf.secondaryText = vm.rating
        c.contentConfiguration = conf
        c.accessoryType = .disclosureIndicator
        return c
    }

    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelect(row: indexPath.row)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let del = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _,_,done in
            self?.presenter?.didDelete(row: indexPath.row)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [del])
    }
}
