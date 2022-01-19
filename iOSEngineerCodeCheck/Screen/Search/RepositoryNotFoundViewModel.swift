//
//  RepositoryNotFoundViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol RepositoryNotFoundViewModelOutputs {
    var isPresent: AnyPublisher<Bool, Never> { get }
}

protocol RepositoryNotFoundViewModelType {
    var outputs: RepositoryNotFoundViewModelOutputs { get }
}

final class RepositoryNotFoundViewModel: RepositoryNotFoundViewModelType {
    var outputs: RepositoryNotFoundViewModelOutputs { self }
    private let repository: SearchRepositoryRepositoryProtocol
    private var cancellable: AnyCancellable?
    private let isPresentsubject = PassthroughSubject<Bool, Never>()

    init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
    }

    private func bind() {
        cancellable = repository.items
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure = completion {
                    self?.isPresentsubject.send(false)
                }
            }, receiveValue: { [weak self] items in
                let isPresent = items.isEmpty
                self?.isPresentsubject.send(isPresent)
            })
    }
}

extension RepositoryNotFoundViewModel: RepositoryNotFoundViewModelOutputs {
    var isPresent: AnyPublisher<Bool, Never> {
        isPresentsubject.eraseToAnyPublisher()
    }
}
