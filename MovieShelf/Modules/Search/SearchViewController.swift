//
//  SearchViewController.swift
//  MovieShelf
//
//  Created by Thalita Auad on 06/11/25.
//

import UIKit

final class SearchViewController: UIViewController, SearchViewInput {
    var presenter: SearchViewOutput?

    static func make(deps: Deps) -> UIViewController {
        let vc = SearchViewController()
        let interactor = SearchInteractor()
        let router = SearchRouter(deps: deps)
        router.viewController = vc
        let presenter = SearchPresenter(view: vc, interactor: interactor, router: router)
        vc.presenter = presenter
        return vc
    }

    // MARK: - UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Search movies"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false; return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Type a movie title…"
        tf.borderStyle = .roundedRect
        tf.returnKeyType = .search
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let searchButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Search"
        let b = UIButton(configuration: config)
        b.isEnabled = false
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground; title = "MovieShelf"
        setupLayout(); setupActions()
        presenter?.viewDidLoad()
    }

    private func setupLayout() {
        view.addSubview(titleLabel); view.addSubview(textField)
        view.addSubview(errorLabel); view.addSubview(searchButton)
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 44),

            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 6),
            errorLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),

            searchButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            searchButton.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    private func setupActions() {
        textField.addTarget(self, action: #selector(onChange), for: .editingChanged)
        textField.delegate = self
        searchButton.addTarget(self, action: #selector(onSearch), for: .touchUpInside)
    }
    
    @objc private func onChange() { presenter?.didChangeQuery(textField.text ?? "") }
    @objc private func onSearch() { view.endEditing(true); presenter?.didTapSearch() }

    //MARK: - ViewInput
    func setButtonEnabled(_ enabled: Bool) {
        searchButton.isEnabled = enabled
        searchButton.alpha = enabled ? 1 : 0.6
    }
    
    func showError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = (message == nil)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { presenter?.didPressReturn(); return true }
}
