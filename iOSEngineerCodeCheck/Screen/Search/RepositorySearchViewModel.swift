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
    func searchRepository(by word: String)
    func onTapTableViewCell(index: Int)
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
    private var searchCancellable: AnyCancellable?
    private let repository = GithubRepositoryRepository()
    private let fetchSuccessSubject = PassthroughSubject<Void, Never>()
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private let onTransitionDetailSubject = PassthroughSubject<Item, Never>()
}

extension RepositorySearchViewModel: RepositorySearchViewModelInputs {
    func searchRepository(by word: String) {
        searchCancellable?.cancel()
        searchCancellable = repository.searchRepositories(by: word)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case let .failure(error):
                    self?.errorMessageSubject.send(error.localizedDescription)
                default: break
                }
            }, receiveValue: { [weak self] _ in
                self?.fetchSuccessSubject.send()
            })
    }

    func onTapTableViewCell(index: Int) {
        guard let item = repository.response?.items[index] else { return }
        onTransitionDetailSubject.send(item)
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
        repository.response?.items ?? []
    }
}
