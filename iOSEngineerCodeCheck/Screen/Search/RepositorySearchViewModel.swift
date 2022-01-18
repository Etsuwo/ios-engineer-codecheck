//
//  RepositorySearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol RepositorySearchViewModelInputs {
    func onTapSearchButton(with word: String)
    func onTapTableViewCell(index: Int)
    func onReachedBottomTableView()
}

protocol RepositorySearchViewModelOutputs {
    var fetchSuccess: AnyPublisher<Void, Never> { get }
    var errorMessage: AnyPublisher<String, Never> { get }
    var onTransitionDetail: AnyPublisher<Item, Never> { get }
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
    private let repository: GithubRepositoryRepositoryProtocol
    private var dataStore = DataStore()
    private let fetchSuccessSubject = PassthroughSubject<Void, Never>()
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private let onTransitionDetailSubject = PassthroughSubject<Item, Never>()

    init(repository: GithubRepositoryRepositoryProtocol = GithubRepositoryRepository()) {
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

    private func searchRepository(by word: String) {
        dataStore.searchWord = word
        searchCancellable?.cancel()
        searchCancellable = repository.searchRepositories(by: word, isPagination: false)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.errorMessageSubject.send(error.localizedDescription)
                default: break
                }
            }, receiveValue: { [weak self] response in
                self?.dataStore.items = response.items
                self?.fetchSuccessSubject.send()
            })
    }

    private func pagination() {
        searchCancellable?.cancel()
        searchCancellable = repository.searchRepositories(by: dataStore.searchWord, isPagination: true)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.errorMessageSubject.send(error.localizedDescription)
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

    var errorMessage: AnyPublisher<String, Never> {
        errorMessageSubject.eraseToAnyPublisher()
    }

    var onTransitionDetail: AnyPublisher<Item, Never> {
        onTransitionDetailSubject.eraseToAnyPublisher()
    }

    var items: [Item] {
        dataStore.items
    }
}
