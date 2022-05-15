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

public protocol IndicatorViewModelOutputs {
    var isLoading: AnyPublisher<Bool, Never> { get }
}

public protocol IndicatorViewModelType {
    var outputs: IndicatorViewModelOutputs { get }
}

public final class IndicatorViewModel: IndicatorViewModelType {
    public var outputs: IndicatorViewModelOutputs { self }
    private let repository: SearchRepositoryRepositoryProtocol

    public init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
    }
}

extension IndicatorViewModel: IndicatorViewModelOutputs {
    public var isLoading: AnyPublisher<Bool, Never> {
        repository.isLoading
    }
}
