//
//  RepositorySearchCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

final class RepositorySearchCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!

    static let identifier = "RepositorySearchCell"

    func configure(with item: Item) {
        avatarImageView.kf.setImage(with: URL(string: item.owner.avatarUrl))
        ownerNameLabel.text = L10n.RepositorySearch.OwnerNameLabel.text(item.owner.login)
        repositoryNameLabel.text = item.name
        descriptionLabel.text = item.description
        detailLabel.text = L10n.RepositorySearch.DetailLabel.text(item.language ?? L10n.Common.blank, item.stargazersCount)
    }
}
