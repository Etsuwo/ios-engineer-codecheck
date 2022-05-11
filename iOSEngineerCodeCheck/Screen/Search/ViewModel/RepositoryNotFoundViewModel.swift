//
//  RepositoryNotFoundViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation
import Repositories

protocol RepositoryNotFoundViewModelOutputs {
    var isPresent: AnyPublisher<Bool, Never> { get }
}

protocol RepositoryNotFoundViewModelType {
    var outputs: RepositoryNotFoundViewModelOutputs { get }
}

final class RepositoryNotFoundViewModel: RepositoryNotFoundViewModelType {
    var outputs: RepositoryNotFoundViewModelOutputs { self }
    private let repository: SearchRepositoryRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private let isPresentsubject = PassthroughSubject<Bool, Never>()

    init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
        bind()
    }

    private func bind() {
        repository.fetchSuccess
            .sink(receiveValue: { [weak self] items in
                let isPresent = items.isEmpty
                self?.isPresentsubject.send(isPresent)
            })
            .store(in: &cancellables)
        repository.isError
            .sink(receiveValue: { [weak self] _ in
                self?.isPresentsubject.send(false)
            })
            .store(in: &cancellables)
    }
}

extension RepositoryNotFoundViewModel: RepositoryNotFoundViewModelOutputs {
    var isPresent: AnyPublisher<Bool, Never> {
        isPresentsubject.eraseToAnyPublisher()
    }
}
