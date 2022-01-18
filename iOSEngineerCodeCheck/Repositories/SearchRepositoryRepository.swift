//
//  GithubRepositoryRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol SearchRepositoryRepositoryProtocol {
    func searchRepositories(by word: String, isPagination: Bool) -> AnyPublisher<SearchRepositoriesResponse, Error>
}

final class SearchRepositoryRepository: SearchRepositoryRepositoryProtocol {
    private let provider: GithubAPIProviderProtocol
    private var page = 1
    private var perPage = 30
    private var canPagination = true

    init(provider: GithubAPIProviderProtocol = GithubAPIProvider()) {
        self.provider = provider
    }

    /// Githubのリポジトリ検索をProviderに依頼
    /// - Parameter word: 検索ワード
    /// - Parameter isPageNation: ページネーションか否か
    /// - Returns: SearchRepositoriesResponseを流すPublisher
    func searchRepositories(by word: String, isPagination: Bool) -> AnyPublisher<SearchRepositoriesResponse, Error> {
        // 汚いのでどこかへ切り出したい
        if isPagination {
            page += 1
        } else {
            page = 1
            canPagination = true
        }

        // ページネーションできない場合はエラーを返す
        guard canPagination else {
            return Fail(outputType: SearchRepositoriesResponse.self, failure: APIError.noMoreContent).eraseToAnyPublisher()
        }

        let request = SearchRepositoriesRequest(searchWord: word, page: page)
        return provider.exec(with: request)
            .tryMap { [weak self] response in
                guard let strongSelf = self else { return response }
                if response.items.isEmpty {
                    strongSelf.canPagination = false
                }
                return response
            }
            .eraseToAnyPublisher()
    }
}
