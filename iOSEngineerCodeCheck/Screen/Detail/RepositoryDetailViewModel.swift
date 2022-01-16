//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol RepositoryDetailViewModelInputs {}

protocol RepositoryDetailViewModelOutputs {
    var fullName: String { get }
    var language: String { get }
    var stargazersCount: Int { get }
    var watchersCount: Int { get }
    var forksCount: Int { get }
    var openIssuesCount: Int { get }
    var avatarUrl: URL? { get }
}

protocol RepositoryDetailViewModelType {
    var inputs: RepositoryDetailViewModelInputs { get }
    var outputs: RepositoryDetailViewModelOutputs { get }
}

final class RepositoryDetailViewModel: RepositoryDetailViewModelType {
    var inputs: RepositoryDetailViewModelInputs { self }
    var outputs: RepositoryDetailViewModelOutputs { self }
    private let item: Item

    init(item: Item) {
        self.item = item
    }
}

extension RepositoryDetailViewModel: RepositoryDetailViewModelInputs {}

extension RepositoryDetailViewModel: RepositoryDetailViewModelOutputs {
    var fullName: String { item.fullName }
    var language: String { item.language ?? L10n.Common.blank }
    var stargazersCount: Int { item.stargazersCount }
    var watchersCount: Int { item.watchersCount }
    var forksCount: Int { item.forksCount }
    var openIssuesCount: Int { item.openIssuesCount }
    var avatarUrl: URL? { URL(string: item.owner.avatarUrl) }
}
