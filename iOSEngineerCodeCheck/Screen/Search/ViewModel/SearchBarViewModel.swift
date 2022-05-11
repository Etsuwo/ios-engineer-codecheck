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

protocol SearchBarViewModelInputs {
    func textDidChange(to word: String)
}

protocol SearchBarViewModelType {
    var inputs: SearchBarViewModelInputs { get }
}

final class SearchBarViewModel: SearchBarViewModelType {
    var inputs: SearchBarViewModelInputs { self }
    private let repository: SearchRepositoryRepositoryProtocol

    init(repository: SearchRepositoryRepositoryProtocol) {
        self.repository = repository
    }
}

extension SearchBarViewModel: SearchBarViewModelInputs {
    func textDidChange(to word: String) {
        repository.searchRepositories(by: word, isPagination: false)
    }
}
