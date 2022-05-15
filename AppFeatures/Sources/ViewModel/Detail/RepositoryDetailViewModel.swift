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
import Repositories
import Resources

public protocol RepositoryDetailViewModelInputs {
    func fetchReadme()
}

public protocol RepositoryDetailViewModelOutputs {
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

public protocol RepositoryDetailViewModelType {
    var inputs: RepositoryDetailViewModelInputs { get }
    var outputs: RepositoryDetailViewModelOutputs { get }
}

public final class RepositoryDetailViewModel: RepositoryDetailViewModelType {
    public var inputs: RepositoryDetailViewModelInputs { self }
    public var outputs: RepositoryDetailViewModelOutputs { self }
    private let repository: GetReadmeRepositoryProtocol
    private let item: Item

    public init(item: Item, repository: GetReadmeRepositoryProtocol = GetReadmeRepository()) {
        self.item = item
        self.repository = repository
    }
}

extension RepositoryDetailViewModel: RepositoryDetailViewModelInputs {
    public func fetchReadme() {
        repository.getReadme(owner: item.owner.login, repository: item.name)
    }
}

extension RepositoryDetailViewModel: RepositoryDetailViewModelOutputs {
    public var repositoryName: String { item.name }
    public var ownerName: String { item.owner.login }
    public var description: String { item.description ?? L10n.Common.blank }
    public var language: String { item.language ?? L10n.Common.blank }
    public var stargazersCount: Int { item.stargazersCount }
    public var watchersCount: Int { item.watchersCount }
    public var forksCount: Int { item.forksCount }
    public var openIssuesCount: Int { item.openIssuesCount }
    public var avatarUrl: URL? { URL(string: item.owner.avatarUrl) }
    public var readme: AnyPublisher<String, Never> { repository.readme }
    public var isLoading: AnyPublisher<Bool, Never> { repository.isLoading }
}
