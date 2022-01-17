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

final class RepositorySearchViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: Propaties

    private let viewModel: RepositorySearchViewModelType = RepositorySearchViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUIAction()
        bindViewModel()
    }

    // MARK: Private Methods

    private func setupUI() {
        tableView.dataSource = self
    }

    private func bindUIAction() {
        tableView.didSelectRowPublisher
            .sink(receiveValue: { [weak self] indexPath in
                self?.viewModel.inputs.onTapTableViewCell(index: indexPath.row)
            })
            .store(in: &cancellables)
        searchBar.searchButtonClickedPublisher
            .sink(receiveValue: { [weak self] in
                guard let searchWord = self?.searchBar.text, searchWord.isNotEmpty else { return }
                self?.viewModel.inputs.onTapSearchButton(with: searchWord)
            })
            .store(in: &cancellables)
    }

    private func bindViewModel() {
        viewModel.outputs.fetchSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
        viewModel.outputs.onTransitionDetail
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] item in
                let detailVC = StoryboardScene.Main.repositoryDetailViewController.instantiate()
                detailVC.configure(with: item)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .store(in: &cancellables)
    }
}

// MARK: TableView DataSource

extension RepositorySearchViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.outputs.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositorySearchCell.identifier, for: indexPath)
        guard let repositoryCell = cell as? RepositorySearchCell else {
            return cell
        }
        let item = viewModel.outputs.items[indexPath.row]
        repositoryCell.configure(with: item)
        cell.tag = indexPath.row

        return cell
    }
}
