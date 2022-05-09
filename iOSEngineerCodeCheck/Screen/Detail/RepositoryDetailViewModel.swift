//
//  RepositoryDetailViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import API
import Combine
import Foundation

protocol RepositoryDetailViewModelInputs {
    func fetchReadme()
}

protocol RepositoryDetailViewModelOutputs {
    var repositoryName: String { get }
    var ownerName: String { get }
    var description: String { get }
    var language: String { get }
    var stargazersCount: Int { get }
    var watchersCount: Int { get }
    var forksCount: Int { get }
    var openIssuesCount: Int { get }
    var avatarUrl: URL? { get }
    var readme: AnyPublisher<String, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
}

protocol RepositoryDetailViewModelType {
    var inputs: RepositoryDetailViewModelInputs { get }
    var outputs: RepositoryDetailViewModelOutputs { get }
}

final class RepositoryDetailViewModel: RepositoryDetailViewModelType {
    var inputs: RepositoryDetailViewModelInputs { self }
    var outputs: RepositoryDetailViewModelOutputs { self }
    private let repository: GetReadmeRepositoryProtocol
    private let item: Item

    init(item: Item, repository: GetReadmeRepositoryProtocol = GetReadmeRepository()) {
        self.item = item
        self.repository = repository
    }
}

extension RepositoryDetailViewModel: RepositoryDetailViewModelInputs {
    func fetchReadme() {
        repository.getReadme(owner: item.owner.login, repository: item.name)
    }
}

extension RepositoryDetailViewModel: RepositoryDetailViewModelOutputs {
    var repositoryName: String { item.name }
    var ownerName: String { item.owner.login }
    var description: String { item.description ?? L10n.Common.blank }
    var language: String { item.language ?? L10n.Common.blank }
    var stargazersCount: Int { item.stargazersCount }
    var watchersCount: Int { item.watchersCount }
    var forksCount: Int { item.forksCount }
    var openIssuesCount: Int { item.openIssuesCount }
    var avatarUrl: URL? { URL(string: item.owner.avatarUrl) }
    var readme: AnyPublisher<String, Never> { repository.readme }
    var isLoading: AnyPublisher<Bool, Never> { repository.isLoading }
}
