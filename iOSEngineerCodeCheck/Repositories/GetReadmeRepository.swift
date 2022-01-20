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
    func getReadme(owner: String, repository: String)
    var readme: AnyPublisher<String, Never> { get }
}

final class GetReadmeRepository: GetReadmeRepositoryProtocol {
    private let provider: GithubAPIProviderProtocol
    private let readmeSubject = PassthroughSubject<String, Never>()
    private var cancellable: AnyCancellable?
    var readme: AnyPublisher<String, Never> {
        readmeSubject.eraseToAnyPublisher()
    }

    init(provider: GithubAPIProviderProtocol = GithubAPIProvider()) {
        self.provider = provider
    }

    /// リポジトリのREADME.mdの取得をProviderに依頼
    /// - Parameters:
    ///   - owner: リポジトリ所有者の名前
    ///   - repository: リポジトリ名
    func getReadme(owner: String, repository: String) {
        let request = GetReadmeRequest(owner: owner, repo: repository)
        cancellable = provider.exec(with: request)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] data in
                guard let data = Data(base64Encoded: data.content, options: .ignoreUnknownCharacters),
                      let readme = String(data: data, encoding: .utf8)
                else {
                    return
                }
                self?.readmeSubject.send(readme)
            })
    }
}
