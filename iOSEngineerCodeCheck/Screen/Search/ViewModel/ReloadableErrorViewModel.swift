//
//  ReloadableErrorViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol ReloadableErrorViewModelInputs {
    func onTapReloadButton()
}

protocol ReloadableErrorViewModelOutputs {
    var isPresent: AnyPublisher<Bool, Never> { get }
}

protocol ReloadableErrorViewModelType {
    var inputs: ReloadableErrorViewModelInputs { get }
    var outputs: ReloadableErrorViewModelOutputs { get }
}

final class ReloadableErrorViewModel: ReloadableErrorViewModelType {
    var inputs: ReloadableErrorViewModelInputs { self }
    var outputs: ReloadableErrorViewModelOutputs { self }
    private let repository: SearchRepositoryRepositoryProtocol
    private let isPresentSubject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
        bind()
    }

    private func bind() {
        repository.fetchSuccess
            .sink(receiveValue: { [weak self] _ in
                self?.isPresentSubject.send(false)
            })
            .store(in: &cancellables)
        repository.isError
            .sink(receiveValue: { [weak self] _ in
                self?.isPresentSubject.send(true)
            })
            .store(in: &cancellables)
    }
}

extension ReloadableErrorViewModel: ReloadableErrorViewModelInputs {
    func onTapReloadButton() {
        repository.searchRepositories(by: nil, isPagination: false)
    }
}

extension ReloadableErrorViewModel: ReloadableErrorViewModelOutputs {
    var isPresent: AnyPublisher<Bool, Never> {
        isPresentSubject.eraseToAnyPublisher()
    }
}
