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
}

final class GithubRepositoryRepository: GithubRepositoryRepositoryProtocol {
    private let provider: GithubAPIProviderProtocol

    init() {
        provider = GithubAPIProvider()
    }

    /// Githubのリポジトリを検索する
    func searchRepositories(by word: String) -> AnyPublisher<SearchRepositoriesResponse, Error> {
        let request = SearchRepositoriesRequest(searchWord: word)
        return provider.exec(with: request)
            .eraseToAnyPublisher()
    }
}
