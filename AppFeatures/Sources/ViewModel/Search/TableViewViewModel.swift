//
//  TableViewViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import API
import Combine
import Foundation
import Repositories

public protocol TableViewViewModelInputs {
    func onTapTableViewCell(index: Int)
    func onReachedBottomTableView()
    func onPullToRefresh()
}

public protocol TableViewViewModelOutputs {
    var isSuccessSearchRepository: AnyPublisher<Bool, Never> { get }
    var onTransitionDetail: AnyPublisher<Item, Never> { get }
    var item: [Item] { get }
}

public protocol TableViewViewModelType {
    var inputs: TableViewViewModelInputs { get }
    var outputs: TableViewViewModelOutputs { get }
}

public final class TableViewViewModel: TableViewViewModelType {
    public var inputs: TableViewViewModelInputs { self }
    public var outputs: TableViewViewModelOutputs { self }
    private let repository: SearchRepositoryRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private let isSuccessSearchRepositorySubject = PassthroughSubject<Bool, Never>()
    private let onTransitionDetailSubject = PassthroughSubject<Item, Never>()

    public init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
        bind()
    }

    private func bind() {
        repository.fetchSuccess
            .sink(receiveValue: { [weak self] items in
                let isSuccess = !items.isEmpty
                self?.isSuccessSearchRepositorySubject.send(isSuccess)
            })
            .store(in: &cancellables)
        repository.isError
            .sink(receiveValue: { [weak self] _ in
                self?.isSuccessSearchRepositorySubject.send(false)
            })
            .store(in: &cancellables)
    }
}

extension TableViewViewModel: TableViewViewModelInputs {
    public func onTapTableViewCell(index: Int) {
        let item = repository.currentItems[index]
        onTransitionDetailSubject.send(item)
    }

    public func onReachedBottomTableView() {
        repository.searchRepositories(by: nil, isPagination: true)
    }

    public func onPullToRefresh() {
        repository.searchRepositories(by: nil, isPagination: false)
    }
}

extension TableViewViewModel: TableViewViewModelOutputs {
    public var isSuccessSearchRepository: AnyPublisher<Bool, Never> {
        isSuccessSearchRepositorySubject.eraseToAnyPublisher()
    }

    public var onTransitionDetail: AnyPublisher<Item, Never> {
        onTransitionDetailSubject.eraseToAnyPublisher()
    }

    public var item: [Item] {
        repository.currentItems
    }
}
