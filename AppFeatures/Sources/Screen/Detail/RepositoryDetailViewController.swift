//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import API
import Combine
import Kingfisher
import MarkdownView
import Resources
import UIKit
import ViewModel

public final class RepositoryDetailViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    @IBOutlet private weak var forksCountLabel: UILabel!
    @IBOutlet private weak var issuesCountLabel: UILabel!
    @IBOutlet private weak var watchersCountLabel: UILabel!
    @IBOutlet private weak var readmeMarkdownView: MarkdownView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    // MARK: Propaties

    private var viewModel: RepositoryDetailViewModelType!
    private var cancellables = Set<AnyCancellable>()

    // MARK: LifeCycle

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.inputs.fetchReadme()
    }

    // MARK: Public Methods

    /// このViewControllerに遷移する前に呼んで表示するリポジトリを渡してあげる
    /// - Parameter item: 表示するリポジトリ
    public func configure(with item: Item) {
        viewModel = RepositoryDetailViewModel(item: item)
    }

    // MARK: Private Methods

    private func setupUI() {
        repositoryNameLabel.text = viewModel.outputs.repositoryName
        ownerNameLabel.text = viewModel.outputs.ownerName
        descriptionLabel.text = viewModel.outputs.description
        detailLabel.text = L10n.RepositoryDetail.DetailLabel.text(viewModel.outputs.language, viewModel.outputs.stargazersCount)
        forksCountLabel.text = String(viewModel.outputs.forksCount)
        issuesCountLabel.text = String(viewModel.outputs.openIssuesCount)
        watchersCountLabel.text = String(viewModel.outputs.watchersCount)
        avatarImageView.kf.setImage(with: viewModel.outputs.avatarUrl)

        readmeMarkdownView.isScrollEnabled = false
        readmeMarkdownView.onRendered = { [weak self] height in
            // 高さの調整
            self?.readmeMarkdownView.heightAnchor.constraint(equalToConstant: height).isActive = true
            self?.view.layoutIfNeeded()
        }
    }

    private func bindViewModel() {
        viewModel.outputs.readme
            .sink(receiveValue: { [weak self] readme in
                self?.readmeMarkdownView.load(markdown: readme)
            })
            .store(in: &cancellables)
        viewModel.outputs.isLoading
            .receive(on: DispatchQueue.main)
            .map { !$0 }
            .assign(to: \.isHidden, on: activityIndicatorView)
            .store(in: &cancellables)
    }
}
