//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Kingfisher
import UIKit

final class RepositoryDetailViewController: UIViewController {
    // MARK: IBOutlet

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsCountLabel: UILabel!
    @IBOutlet private weak var watchersCountLabel: UILabel!
    @IBOutlet private weak var forksCountLabel: UILabel!
    @IBOutlet private weak var issuesCountLabel: UILabel!

    // MARK: Propaties

    private var repository: Item!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Public Methods

    /// このViewControllerに遷移する前に呼んで表示するリポジトリを渡してあげる
    func configure(with repository: Item) {
        self.repository = repository
    }

    // MARK: Private Methods

    private func setupUI() {
        fullNameLabel.text = repository.fullName
        languageLabel.text = L10n.RepositoryDetail.LanguageLabel.text(repository.language ?? "")
        starsCountLabel.text = L10n.RepositoryDetail.StarsCountLabel.text(repository.stargazersCount)
        watchersCountLabel.text = L10n.RepositoryDetail.WatchersCountLabel.text(repository.watchersCount)
        forksCountLabel.text = L10n.RepositoryDetail.ForksCountLabel.text(repository.forksCount)
        issuesCountLabel.text = L10n.RepositoryDetail.IssueCountLabel.text(repository.openIssuesCount)
        avatarImageView.kf.setImage(with: URL(string: repository.owner.avatarUrl))
    }
}
