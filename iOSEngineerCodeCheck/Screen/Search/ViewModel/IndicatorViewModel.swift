//
//  IndicatorViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation
import Repositories

protocol IndicatorViewModelOutputs {
    var isLoading: AnyPublisher<Bool, Never> { get }
}

protocol IndicatorViewModelType {
    var outputs: IndicatorViewModelOutputs { get }
}

final class IndicatorViewModel: IndicatorViewModelType {
    var outputs: IndicatorViewModelOutputs { self }
    private let repository: SearchRepositoryRepositoryProtocol

    init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
    }
}

extension IndicatorViewModel: IndicatorViewModelOutputs {
    var isLoading: AnyPublisher<Bool, Never> {
        repository.isLoading
    }
}
