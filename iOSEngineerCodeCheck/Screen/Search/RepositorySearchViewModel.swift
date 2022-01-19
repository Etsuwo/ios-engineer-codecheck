//
//  RepositorySearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol RepositorySearchViewModelInputs: ReloadableErrorViewModelProtocol {
    func onTapSearchButton(with word: String)
    func onTapTableViewCell(index: Int)
    func onReachedBottomTableView()
    func onPullToRefresh()
}

protocol RepositorySearchViewModelOutputs {
    var fetchSuccess: AnyPublisher<Void, Never> { get }
    var repositoryNotFound: AnyPublisher<Void, Never> { get }
    var fetchError: AnyPublisher<Void, Never> { get }
    var onTransitionDetail: AnyPublisher<Item, Never> { get }
    var isLoading: AnyPublisher<Bool, Never> { get }
    var items: [Item] { get }
}

protocol RepositorySearchViewModelType {
    var inputs: RepositorySearchViewModelInputs { get }
    var outputs: RepositorySearchViewModelOutputs { get }
}

final class RepositorySearchViewModel: RepositorySearchViewModelType {
    var inputs: RepositorySearchViewModelInputs { self }
    var outputs: RepositorySearchViewModelOutputs { self }

    struct DataStore {
        var items: [Item] = []
        var searchWord: String = ""
    }

    private var searchCancellable: AnyCancellable?
    private let repository: SearchRepositoryRepositoryProtocol
    private var dataStore = DataStore()
    private let fetchSuccessSubject = PassthroughSubject<Void, Never>()
    private let repositoryNotFoundSubject = PassthroughSubject<Void, Never>()
    private let fetchErrorSubject = PassthroughSubject<Void, Never>()
    private let onTransitionDetailSubject = PassthroughSubject<Item, Never>()
    private let isLoadingSubject = PassthroughSubject<Bool, Never>()

    init(repository: SearchRepositoryRepositoryProtocol = SearchRepositoryRepository()) {
        self.repository = repository
    }
}

extension RepositorySearchViewModel: RepositorySearchViewModelInputs {
    /// SearchButtonがタップされた時に呼ぶ
    /// - Parameter word: SearchBarに入力された文字列
    func onTapSearchButton(with word: String) {
        searchRepository(by: word)
    }

    /// TableViewCellがタップされた時に呼ぶ
    /// - Parameter index: タップされたCellのIndexPath.row
    func onTapTableViewCell(index: Int) {
        onTransitionDetailSubject.send(dataStore.items[index])
    }

    func onReachedBottomTableView() {
        pagination()
    }

    /// pull to resreshされた時に呼ぶ
    func onPullToRefresh() {
        searchRepository(by: dataStore.searchWord)
    }

    func reload() {
        searchRepository(by: dataStore.searchWord)
    }

    private func searchRepository(by word: String) {
        isLoadingSubject.send(true)
        dataStore.searchWord = word
        searchCancellable?.cancel()
        searchCancellable = repository.searchRepositories(by: word, isPagination: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    print(error.localizedDescription)
                    self?.fetchErrorSubject.send()
                default: break
                }
                self?.isLoadingSubject.send(false)
            }, receiveValue: { [weak self] response in
                self?.dataStore.items = response.items
                response.items.isEmpty ? self?.repositoryNotFoundSubject.send() : self?.fetchSuccessSubject.send()
            })
    }

    private func pagination() {
        searchCancellable?.cancel()
        searchCancellable = repository.searchRepositories(by: dataStore.searchWord, isPagination: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    if case APIError.noMoreContent = error { break }
                    print(error.localizedDescription)
                    self?.fetchErrorSubject.send()
                default: break
                }
            }, receiveValue: { [weak self] response in
                self?.dataStore.items.append(contentsOf: response.items)
                self?.fetchSuccessSubject.send()
            })
    }
}

extension RepositorySearchViewModel: RepositorySearchViewModelOutputs {
    var fetchSuccess: AnyPublisher<Void, Never> {
        fetchSuccessSubject.eraseToAnyPublisher()
    }

    var repositoryNotFound: AnyPublisher<Void, Never> {
        repositoryNotFoundSubject.eraseToAnyPublisher()
    }

    var fetchError: AnyPublisher<Void, Never> {
        fetchErrorSubject.eraseToAnyPublisher()
    }

    var onTransitionDetail: AnyPublisher<Item, Never> {
        onTransitionDetailSubject.eraseToAnyPublisher()
    }

    var isLoading: AnyPublisher<Bool, Never> {
        isLoadingSubject.eraseToAnyPublisher()
    }

    var items: [Item] {
        dataStore.items
    }
}
