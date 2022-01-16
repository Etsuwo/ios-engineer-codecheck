//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import UIKit

final class RepositorySearchViewController: UITableViewController {
    // MARK: IBOutlet

    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: Propaties

    private let repository = GithubRepositoryRepository()
    private var cancellable: AnyCancellable?

    // MARK: Constants

    private enum Constants {
        static let cellIdentifier = "RepositoryCell"
    }

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Private Methods

    private func setupUI() {
        searchBar.text = L10n.RepositorySearch.SearchBar.text
        searchBar.delegate = self
    }

    private func searchRepository(by word: String) {
        cancellable?.cancel()
        cancellable = repository.searchRepositories(by: word)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                default: break
                }
            }, receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
    }

    private func transitionToDetail(with repository: Item) {
        let detailVC = StoryboardScene.Main.repositoryDetailViewController.instantiate()
        detailVC.configure(with: repository)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: TableView Methods

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        repository.response?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        if let repository = repository.response?.items[indexPath.row] {
            cell.textLabel?.text = repository.fullName
            cell.detailTextLabel?.text = repository.language ?? ""
            cell.tag = indexPath.row
        }
        return cell
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let repository = repository.response?.items[indexPath.row] else { return }
        transitionToDetail(with: repository)
    }
}

// MARK: UISearchBarDelegate

extension RepositorySearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = L10n.Common.blank
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        if searchWord.isNotEmpty {
            searchRepository(by: searchWord)
        }
    }
}
