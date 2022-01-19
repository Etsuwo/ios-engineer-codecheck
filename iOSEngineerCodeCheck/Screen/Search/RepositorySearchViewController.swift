//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
import CombineCocoa
import SwiftUI
import UIKit

final class RepositorySearchViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var presenterView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: Propaties

    private let viewModel: RepositorySearchViewModelType = RepositorySearchViewModel()
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
                self?.viewModel.inputs.onTapTableViewCell(index: indexPath.row)
            })
            .store(in: &cancellables)
        tableView.reachedBottomPublisher()
            .sink(receiveValue: { [weak self] in
                self?.viewModel.inputs.onReachedBottomTableView()
            })
            .store(in: &cancellables)
        refreshControl.isRefreshingPublisher
            .sink(receiveValue: { [weak self] isRefresh in
                if isRefresh {
                    self?.viewModel.inputs.onPullToRefresh()
                }
            })
            .store(in: &cancellables)
        searchBar.textDidChangePublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] text in
                guard text.isNotEmpty else { return }
                self?.viewModel.inputs.onTapSearchButton(with: text)
            })
            .store(in: &cancellables)
        searchBar.searchButtonClickedPublisher
            .sink(receiveValue: { [weak self] in
                self?.searchBar.endEditing(false)
            })
            .store(in: &cancellables)
    }

    private func bindViewModel() {
        viewModel.outputs.fetchSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                self?.reloadableErrorViewHandler.dismiss()
                self?.repositoryNotFoundViewHandler.dismiss()
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            })
            .store(in: &cancellables)
        viewModel.outputs.repositoryNotFound
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.tableView.isHidden = true
                strongSelf.reloadableErrorViewHandler.dismiss()
                let repositoryNotFoundView = RepositoryNotFoundView()
                strongSelf.repositoryNotFoundViewHandler.present(to: strongSelf, where: strongSelf.presenterView, hostedView: repositoryNotFoundView)
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
        viewModel.outputs.fetchError
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let strongSelf = self,
                      let viewModel = self?.viewModel as? RepositorySearchViewModel else { return }
                strongSelf.tableView.isHidden = true
                strongSelf.repositoryNotFoundViewHandler.dismiss()
                let reloadableErrorView = ReloadableErrorView(viewModel: viewModel)
                strongSelf.reloadableErrorViewHandler.present(to: strongSelf, where: strongSelf.presenterView, hostedView: reloadableErrorView)
            })
            .store(in: &cancellables)
        viewModel.outputs.isLoading
            .receive(on: DispatchQueue.main)
            .map { !$0 }
            .assign(to: \.isHidden, on: activityIndicatorView)
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
