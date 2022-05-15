//
//  ReloadableErrorViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation
import Repositories

public protocol ReloadableErrorViewModelInputs {
    func onTapReloadButton()
}

public protocol ReloadableErrorViewModelOutputs {
    var isPresent: AnyPublisher<Bool, Never> { get }
}

public protocol ReloadableErrorViewModelType {
    var inputs: ReloadableErrorViewModelInputs { get }
    var outputs: ReloadableErrorViewModelOutputs { get }
}

public final class ReloadableErrorViewModel: ReloadableErrorViewModelType {
    public var inputs: ReloadableErrorViewModelInputs { self }
    public var outputs: ReloadableErrorViewModelOutputs { self }
    private let repository: SearchRepositoryRepositoryProtocol
    private let isPresentSubject = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()

    public init(repository: SearchRepositoryRepositoryProtocol) {
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
    public func onTapReloadButton() {
        repository.searchRepositories(by: nil, isPagination: false)
    }
}

extension ReloadableErrorViewModel: ReloadableErrorViewModelOutputs {
    public var isPresent: AnyPublisher<Bool, Never> {
        isPresentSubject.eraseToAnyPublisher()
    }
}
