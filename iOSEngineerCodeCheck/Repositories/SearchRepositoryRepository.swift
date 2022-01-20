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
    var fetchSuccess: AnyPublisher<[Item], Never> { get }
    var currentItems: [Item] { get }
    var isError: AnyPublisher<Error, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
}

final class SearchRepositoryRepository: SearchRepositoryRepositoryProtocol {
    private let provider: GithubAPIProviderProtocol
    private var cancellable: AnyCancellable?
    private let setting = SearchRepositorySetting()
    private var fetchSuccessSubject = PassthroughSubject<[Item], Never>()
    private var isErrorSubject = PassthroughSubject<Error, Never>()
    private var isLoadingSubject = PassthroughSubject<Bool, Never>()
    private var items: [Item] = []
    var fetchSuccess: AnyPublisher<[Item], Never> {
        fetchSuccessSubject.eraseToAnyPublisher()
    }

    var currentItems: [Item] {
        items
    }

    var isError: AnyPublisher<Error, Never> {
        isErrorSubject.eraseToAnyPublisher()
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
                    self?.isErrorSubject.send(error)
                default: break
                }
                self?.isLoadingSubject.send(false)
            }, receiveValue: { [weak self] response in
                guard let strongSelf = self else { return }
                self?.setting.updateAfter(with: response.items.count)
                var items = response.items
                if isPagination {
                    items = strongSelf.currentItems + items
                }
                self?.items = items
                self?.fetchSuccessSubject.send(items)
            })
    }
}

final class SearchRepositorySetting {
    private(set) var word = ""
    private(set) var page = 1
    private(set) var perPage = 30
    private(set) var canPagination = true

    /// searchRepositoriesを呼ぶ前に呼ぶ
    /// - Parameters:
    ///   - word: 検索ワード
    ///   - isPagination: <#isPagination description#>
    func updateBefore(with word: String?, isPagination: Bool) {
        if isPagination {
            page += 1
        } else {
            page = 1
            canPagination = true
        }
        self.word = word ?? self.word
    }

    /// searchRepositoriesが成功したときに呼ぶ
    /// - Parameter itemCount: <#itemCount description#>
    func updateAfter(with itemCount: Int) {
        if itemCount < perPage {
            canPagination = false
        }
    }
}
