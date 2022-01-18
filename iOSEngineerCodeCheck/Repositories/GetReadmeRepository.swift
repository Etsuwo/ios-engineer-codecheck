//
//  GetReadmeRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
import Foundation

protocol GetReadmeRepositoryProtocol {
    func getReadme(owner: String, repository: String) -> AnyPublisher<GetReadmeResponse, Error>
}

final class GetReadmeRepository: GetReadmeRepositoryProtocol {
    private let provider: GithubAPIProviderProtocol

    init(provider: GithubAPIProviderProtocol = GithubAPIProvider()) {
        self.provider = provider
    }

    /// リポジトリのREADME.mdの取得をProviderに依頼
    /// - Parameters:
    ///   - owner: リポジトリ所有者の名前
    ///   - repository: リポジトリ名
    /// - Returns: GetReadmeResponseを流すPublisher
    func getReadme(owner: String, repository: String) -> AnyPublisher<GetReadmeResponse, Error> {
        let request = GetReadmeRequest(owner: owner, repo: repository)
        return provider.exec(with: request)
            .eraseToAnyPublisher()
    }
}
