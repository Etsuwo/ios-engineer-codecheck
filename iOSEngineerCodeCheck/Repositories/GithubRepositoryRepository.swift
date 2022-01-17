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
    private(set) var response: SearchRepositoriesResponse?
    private let provider: GithubAPIProviderProtocol

    init() {
        provider = GithubAPIProvider()
    }

    /// Githubのリポジトリを検索する
    func searchRepositories(by word: String) -> AnyPublisher<SearchRepositoriesResponse, Error> {
        let request = SearchRepositoriesRequest(searchWord: word)
        return provider.exec(with: request)
            .tryMap { [weak self] response -> SearchRepositoriesResponse in
                self?.response = response
                return response
            }
            .eraseToAnyPublisher()
    }
}
