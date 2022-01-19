//
//  ReloadableErrorViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation
import Combine

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
    private var cancellable: AnyCancellable?
    
    init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
        bind()
    }
    
    private func bind() {
        cancellable = repository.items
            .sink(receiveCompletion: {[weak self] completion in
                switch completion {
                case .failure(_): self?.isPresentSubject.send(true)
                default: break
                }
            }, receiveValue: {[weak self] _ in
                self?.isPresentSubject.send(false)
            })
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
