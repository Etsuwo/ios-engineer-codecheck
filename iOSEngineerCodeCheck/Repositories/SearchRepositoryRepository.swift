//
//  GithubRepositoryRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Alamofire
import Combine
import Foundation

protocol SearchRepositoryRepositoryProtocol {
    func searchRepositories(by word: String?, isPagination: Bool)
    var items: AnyPublisher<[Item], Error> { get }
    var currentItems: [Item] { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
}

final class SearchRepositoryRepository: SearchRepositoryRepositoryProtocol {
    private let provider: GithubAPIProviderProtocol
    private var cancellable: AnyCancellable?
    private let setting = SearchRepositorySetting()
    private var itemsSubject = CurrentValueSubject<[Item], Error>([])
    private var isLoadingSubject = PassthroughSubject<Bool, Never>()
    var items: AnyPublisher<[Item], Error> {
        itemsSubject.eraseToAnyPublisher()
    }

    var currentItems: [Item] {
        itemsSubject.value
    }

    var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }

    init(provider: GithubAPIProviderProtocol = GithubAPIProvider()) {
        self.provider = provider
    }

    /// Githubのリポジトリ検索をProviderに依頼
    /// - Parameter word: 検索ワード
    /// - Parameter isPageNation: ページネーションか否か
    func searchRepositories(by word: String?, isPagination: Bool) {
        setting.updateBefore(with: word, isPagination: isPagination)
        guard setting.canPagination else { return }

        isLoadingSubject.send(true)
        let request = SearchRepositoriesRequest(searchWord: setting.word, page: setting.page)
        cancellable = provider.exec(with: request)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                    self?.itemsSubject.send(completion: .failure(error))
                default: break
                }
                self?.isLoadingSubject.send(false)
            }, receiveValue: { [weak self] response in
                self?.setting.updateAfter(with: response.items.count)
                self?.itemsSubject.send(response.items)
            })
    }
}

final class SearchRepositorySetting {
    private(set) var word = ""
    private(set) var page = 1
    private(set) var perPage = 30
    private(set) var canPagination = true

    func updateBefore(with word: String?, isPagination: Bool) {
        if isPagination {
            page += 1
        } else {
            page = 1
            canPagination = true
        }
        self.word = word ?? self.word
    }

    func updateAfter(with itemCount: Int) {
        if itemCount < perPage {
            canPagination = false
        }
    }
}
