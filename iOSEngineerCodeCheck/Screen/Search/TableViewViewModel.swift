//
//  TableViewViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

protocol TableViewViewModelInputs {
    func onTapTableViewCell(index: Int)
    func onReachedBottomTableView()
    func onPullToRefresh()
}

protocol TableViewViewModelOutputs {
    var isSuccessSearchRepository: AnyPublisher<Bool, Never> { get }
    var onTransitionDetail: AnyPublisher<Item, Never> { get }
    var item: [Item] { get }
}

protocol TableViewViewModelType {
    var inputs: TableViewViewModelInputs { get }
    var outputs: TableViewViewModelOutputs { get }
}

final class TableViewViewModel: TableViewViewModelType {
    var inputs: TableViewViewModelInputs { self }
    var outputs: TableViewViewModelOutputs { self }
    private let repository: SearchRepositoryRepositoryProtocol
    private var cancellable: AnyCancellable?
    private let isSuccessSearchRepositorySubject = PassthroughSubject<Bool, Never>()
    private let onTransitionDetailSubject = PassthroughSubject<Item, Never>()
    
    init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
        bind()
    }
    
    private func bind() {
        cancellable = repository.items
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .failure(_):
                    self?.isSuccessSearchRepositorySubject.send(false)
                default: break
                }
            }, receiveValue: {[weak self] items in
                let isSuccess = !items.isEmpty
                self?.isSuccessSearchRepositorySubject.send(isSuccess)
            })
    }
}

extension TableViewViewModel: TableViewViewModelInputs {
    func onTapTableViewCell(index: Int) {
        let item = repository.currentItems[index]
        onTransitionDetailSubject.send(item)
    }
    
    func onReachedBottomTableView() {
        repository.searchRepositories(by: nil, isPagination: true)
    }
    
    func onPullToRefresh() {
        repository.searchRepositories(by: nil, isPagination: false)
    }
}

extension TableViewViewModel: TableViewViewModelOutputs {
    var isSuccessSearchRepository: AnyPublisher<Bool, Never> {
        isSuccessSearchRepositorySubject.eraseToAnyPublisher()
    }
    
    var onTransitionDetail: AnyPublisher<Item, Never> {
        onTransitionDetailSubject.eraseToAnyPublisher()
    }
    
    var item: [Item] {
        repository.currentItems
    }
}
