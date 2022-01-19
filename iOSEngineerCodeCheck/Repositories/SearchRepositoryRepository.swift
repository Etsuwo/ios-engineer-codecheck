//
//  GithubRepositoryRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation
import Alamofire

protocol SearchRepositoryRepositoryProtocol {
    func searchRepositories(by word: String, isPagination: Bool)
    var items: AnyPublisher<[Item], Error> { get }
}

final class SearchRepositoryRepository: SearchRepositoryRepositoryProtocol {
    private let provider: GithubAPIProviderProtocol
    private var cancellable: AnyCancellable?
    private var itemsSubject = PassthroughSubject<[Item], Error>()
    var items: AnyPublisher<[Item], Error> {
        itemsSubject.eraseToAnyPublisher()
    }
    private var page = 1
    private var perPage = 30
    private var canPagination = true

    init(provider: GithubAPIProviderProtocol = GithubAPIProvider()) {
        self.provider = provider
    }

    /// Githubのリポジトリ検索をProviderに依頼
    /// - Parameter word: 検索ワード
    /// - Parameter isPageNation: ページネーションか否か
    func searchRepositories(by word: String, isPagination: Bool) {
        // 汚いのでどこかへ切り出したい
        if isPagination {
            page += 1
        } else {
            page = 1
            canPagination = true
        }
        guard canPagination else { return }
        
        let request = SearchRepositoriesRequest(searchWord: word, page: page)
        cancellable = provider.exec(with: request)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                    self?.itemsSubject.send(completion: .failure(error))
                default: break
                }
            }, receiveValue: { [weak self] response in
                guard let strongSelf = self else { return }
                if response.items.count < strongSelf.perPage {
                    strongSelf.canPagination = false
                }
                strongSelf.itemsSubject.send(response.items)
            })
    }
}
