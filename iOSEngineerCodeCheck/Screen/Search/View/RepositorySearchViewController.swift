//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import API
import Combine
import CombineCocoa
import Extensions
import SwiftUI
import UIKit
import Util

final class RepositorySearchViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var presenterView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: Propaties

    private let viewModel = RepositorySearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    private var reloadableErrorViewHandler = HostingViewHandler<ReloadableErrorView>()
    private var repositoryNotFoundViewHandler = HostingViewHandler<RepositoryNotFoundView>()

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUIAction()
        bindViewModel()
        setupDismissKeyboardGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.removeHighlight()
    }

    // MARK: Private Methods

    private func setupUI() {
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
    }

    private func bindUIAction() {
        tableView.didSelectRowPublisher
            .sink(receiveValue: { [weak self] indexPath in
                self?.viewModel.tableViewViewModel.inputs.onTapTableViewCell(index: indexPath.row)
            })
            .store(in: &cancellables)
        tableView.reachedBottomPublisher()
            .sink(receiveValue: { [weak self] in
                self?.viewModel.tableViewViewModel.inputs.onReachedBottomTableView()
            })
            .store(in: &cancellables)
        refreshControl.isRefreshingPublisher
            .sink(receiveValue: { [weak self] isRefresh in
                if isRefresh {
                    self?.viewModel.tableViewViewModel.inputs.onPullToRefresh()
                }
            })
            .store(in: &cancellables)
        searchBar.textDidChangePublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard text.isNotEmpty else { return }
                self?.viewModel.searchBarViewModel.inputs.textDidChange(to: text)
            })
            .store(in: &cancellables)
        searchBar.searchButtonClickedPublisher
            .sink(receiveValue: { [weak self] in
                self?.searchBar.endEditing(false)
            })
            .store(in: &cancellables)
    }

    private func bindViewModel() {
        viewModel.tableViewViewModel.outputs.isSuccessSearchRepository
            .sink(receiveValue: { [weak self] isSuccess in
                self?.tableView.isHidden = !isSuccess
                if isSuccess {
                    self?.refreshControl.endRefreshing()
                    self?.tableView.reloadData()
                }
            })
            .store(in: &cancellables)
        viewModel.tableViewViewModel.outputs.onTransitionDetail
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] item in
                let detailVC = StoryboardScene.Main.repositoryDetailViewController.instantiate()
                detailVC.configure(with: item)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            })
            .store(in: &cancellables)
        viewModel.reloadableErrorViewModel.outputs.isPresent
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isPresent in
                guard let strongSelf = self else { return }
                if isPresent {
                    strongSelf.reloadableErrorViewHandler.present(to: strongSelf, where: strongSelf.presenterView, hostedView: ReloadableErrorView(viewModel: strongSelf.viewModel.reloadableErrorViewModel))
                } else {
                    strongSelf.reloadableErrorViewHandler.dismiss()
                }
            })
            .store(in: &cancellables)
        viewModel.repositoryNotFoundViewModel.outputs.isPresent
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isPresent in
                guard let strongSelf = self else { return }
                if isPresent {
                    strongSelf.repositoryNotFoundViewHandler.present(to: strongSelf, where: strongSelf.presenterView, hostedView: RepositoryNotFoundView())
                } else {
                    strongSelf.repositoryNotFoundViewHandler.dismiss()
                }
            })
            .store(in: &cancellables)
        viewModel.indicatorViewModel.outputs.isLoading
            .receive(on: DispatchQueue.main)
            .map { !$0 }
            .assign(to: \.isHidden, on: activityIndicatorView)
            .store(in: &cancellables)
    }
}

// MARK: TableView DataSource

extension RepositorySearchViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.tableViewViewModel.outputs.item.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RepositorySearchCell.identifier, for: indexPath)
        guard let repositoryCell = cell as? RepositorySearchCell else {
            return cell
        }
        let item = viewModel.tableViewViewModel.outputs.item[indexPath.row]
        repositoryCell.configure(with: item)
        cell.tag = indexPath.row

        return cell
    }
}
