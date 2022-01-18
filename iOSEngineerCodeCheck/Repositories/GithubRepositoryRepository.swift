//
//  GithubRepositoryRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol GithubRepositoryRepositoryProtocol {
    func searchRepositories(by word: String) -> AnyPublisher<SearchRepositoriesResponse, Error>
    func getReadme(owner: String, repository: String) -> AnyPublisher<GetReadmeResponse, Error>
}

final class GithubRepositoryRepository: GithubRepositoryRepositoryProtocol {
    private let provider: GithubAPIProviderProtocol

    init(provider: GithubAPIProviderProtocol = GithubAPIProvider()) {
        self.provider = provider
    }

    /// Githubのリポジトリ検索をProviderに依頼
    /// - Parameter word: 検索ワード
    /// - Returns: SearchRepositoriesResponseを流すPublisher
    func searchRepositories(by word: String) -> AnyPublisher<SearchRepositoriesResponse, Error> {
        let request = SearchRepositoriesRequest(searchWord: word)
        return provider.exec(with: request)
            .eraseToAnyPublisher()
    }

    /// リポジトリのREADME.mdの取得をProviderに依頼
    /// - Parameters:
    ///   - owner: リポジトリ所有者の名前
    ///   - repository: リポジトリ名
    /// - Returns: GetReadmeResponseを流すPublisher
    func getReadme(owner: String, repository: String) -> AnyPublisher<GetReadmeResponse, Error> {
        let request = GetReadmeRequest(owner: owner, repo: repository)
        return provider.exec(with: request)
            .eraseToAnyPublisher()
    }
}
