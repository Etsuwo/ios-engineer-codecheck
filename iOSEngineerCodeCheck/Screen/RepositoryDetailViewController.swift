//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

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

    private var repository: [String: Any]!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAvatarImage()
    }

    // MARK: Public Methods

    /// このViewControllerに遷移する前に呼んで表示するリポジトリを渡してあげる
    func configure(with repository: [String: Any]) {
        self.repository = repository
    }

    // MARK: Private Methods

    private func setupUI() {
        fullNameLabel.text = repository["full_name"] as? String ?? L10n.Common.blank
        languageLabel.text = L10n.RepositoryDetail.LanguageLabel.text(repository["language"] as? String ?? L10n.Common.blank)
        starsCountLabel.text = L10n.RepositoryDetail.StarsCountLabel.text(repository["stargazers_count"] as? Int ?? 0)
        watchersCountLabel.text = L10n.RepositoryDetail.WatchersCountLabel.text(repository["wachers_count"] as? Int ?? 0)
        forksCountLabel.text = L10n.RepositoryDetail.ForksCountLabel.text(repository["forks_count"] as? Int ?? 0)
        issuesCountLabel.text = L10n.RepositoryDetail.IssueCountLabel.text(repository["open_issues_count"] as? Int ?? 0)
    }

    private func fetchAvatarImage() {
        guard let owner = repository["owner"] as? [String: Any],
              let stringUrl = owner["avatar_url"] as? String,
              let url = URL(string: stringUrl)
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else {
                print(" ### There is No Data ### ")
                return
            }

            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
        }.resume()
    }
}
