//
//  RepositorySearchCell.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit

final class RepositorySearchCell: UITableViewCell {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var detailLabel: UILabel!
    
    static let identifier = "RepositorySearchCell"
    
}
