//
//  SearchBarViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/19.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation
import Repositories

public protocol SearchBarViewModelInputs {
    func textDidChange(to word: String)
}

public protocol SearchBarViewModelType {
    var inputs: SearchBarViewModelInputs { get }
}

public final class SearchBarViewModel: SearchBarViewModelType {
    public var inputs: SearchBarViewModelInputs { self }
    private let repository: SearchRepositoryRepositoryProtocol

    public init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
    }
}

extension SearchBarViewModel: SearchBarViewModelInputs {
    public func textDidChange(to word: String) {
        repository.searchRepositories(by: word, isPagination: false)
    }
}
