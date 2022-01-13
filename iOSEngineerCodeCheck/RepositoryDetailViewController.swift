//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class RepositoryDetailViewController: UIViewController {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsCountLabel: UILabel!
    @IBOutlet private weak var watchersCountLabel: UILabel!
    @IBOutlet private weak var forksCountLabel: UILabel!
    @IBOutlet private weak var issuesCountLabel: UILabel!

    var repository: [String: Any]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAvatarImage()
    }

    private func setupUI() {
        fullNameLabel.text = repository["full_name"] as? String
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starsCountLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersCountLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issuesCountLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
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
