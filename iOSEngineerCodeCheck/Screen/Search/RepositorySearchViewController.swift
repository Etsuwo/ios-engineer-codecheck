//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import CombineCocoa
import UIKit

final class RepositorySearchViewController: UITableViewController {
    // MARK: IBOutlet

    @IBOutlet private weak var searchBar: UISearchBar!

    // MARK: Propaties

    private let viewModel: RepositorySearchViewModelType = RepositorySearchViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: Constants

    private enum Constants {
        static let cellIdentifier = "RepositoryCell"
    }

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUIAction()
        bindViewModel()
    }

    // MARK: Private Methods

    private func setupUI() {
        searchBar.text = L10n.RepositorySearch.SearchBar.text
        searchBar.delegate = self
    }

    private func bindUIAction() {
        tableView.didSelectRowPublisher
            .sink(receiveValue: { [weak self] indexPath in
                self?.viewModel.inputs.onTapTableViewCell(index: indexPath.row)
            })
            .store(in: &cancellables)
    }

    private func bindViewModel() {
        viewModel.outputs.fetchSuccess
            .sink(receiveValue: { [weak self] in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
        viewModel.outputs.onTransitionDetail
            .sink(receiveValue: { [weak self] item in
                let detailVC = StoryboardScene.Main.repositoryDetailViewController.instantiate()
                detailVC.configure(with: item)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .store(in: &cancellables)
    }

    // MARK: TableView Methods

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.outputs.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        let repository = viewModel.outputs.items[indexPath.row]
        cell.textLabel?.text = repository.fullName
        cell.detailTextLabel?.text = repository.language ?? L10n.Common.blank
        cell.tag = indexPath.row

        return cell
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
            viewModel.inputs.searchRepository(by: searchWord)
        }
    }
}
