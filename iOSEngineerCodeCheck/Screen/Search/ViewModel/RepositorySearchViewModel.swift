//
//  RepositorySearchViewModel.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation
import Repositories

final class RepositorySearchViewModel {
    let searchBarViewModel: SearchBarViewModelType
    let tableViewViewModel: TableViewViewModelType
    let reloadableErrorViewModel: ReloadableErrorViewModelType
    let repositoryNotFoundViewModel: RepositoryNotFoundViewModelType
    let indicatorViewModel: IndicatorViewModelType

    init(repository: SearchRepositoryRepositoryProtocol = SearchRepositoryRepository()) {
        searchBarViewModel = SearchBarViewModel(repository: repository)
        tableViewViewModel = TableViewViewModel(repository: repository)
        reloadableErrorViewModel = ReloadableErrorViewModel(repository: repository)
        repositoryNotFoundViewModel = RepositoryNotFoundViewModel(repository: repository)
        indicatorViewModel = IndicatorViewModel(repository: repository)
    }
}
