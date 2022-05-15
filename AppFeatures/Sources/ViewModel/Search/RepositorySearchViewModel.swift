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

public final class RepositorySearchViewModel {
    public let searchBarViewModel: SearchBarViewModelType
    public let tableViewViewModel: TableViewViewModelType
    public let reloadableErrorViewModel: ReloadableErrorViewModelType
    public let repositoryNotFoundViewModel: RepositoryNotFoundViewModelType
    public let indicatorViewModel: IndicatorViewModelType

    public init(repository: SearchRepositoryRepositoryProtocol = SearchRepositoryRepository()) {
        searchBarViewModel = SearchBarViewModel(repository: repository)
        tableViewViewModel = TableViewViewModel(repository: repository)
        reloadableErrorViewModel = ReloadableErrorViewModel(repository: repository)
        repositoryNotFoundViewModel = RepositoryNotFoundViewModel(repository: repository)
        indicatorViewModel = IndicatorViewModel(repository: repository)
    }
}
