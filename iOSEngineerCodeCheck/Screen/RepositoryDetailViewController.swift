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

    var repository: [String: Any]!

    // MARK: LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAvatarImage()
    }

    // MARK: Private Methods

    private func setupUI() {
        fullNameLabel.text = repository["full_name"] as? String
        languageLabel.text = L10n.RepositoryDetail.LanguageLabel.text(repository["language"] as? String ?? L10n.Common.blank)
        starsCountLabel.text = L10n.RepositoryDetail.StarsCountLabel.text(repository["stargazers_count"] as? Int ?? 0)
        watchersCountLabel.text = L10n.RepositoryDetail.WatchersCountLabel.text(repository["wachers_count"] as? Int ?? 0)
        forksCountLabel.text = L10n.RepositoryDetail.ForksCountLabel.text(repository["forks_count"] as? Int ?? 0)
        issuesCountLabel.text = L10n.RepositoryDetail.IssueCountLabel.text(repository["open_issues_count"] as? Int ?? 0)
    }

    private func fetchAvatarImage() {
        if let owner = repository["owner"] as? [String: Any],
           let imageUrl = owner["avatar_url"] as? String
        {
            URLSession.shared.dataTask(with: URL(string: imageUrl)!) { data, _, _ in
                let image = UIImage(data: data!)!
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }.resume()
        }
    }
}
