//
//  GithubRepositoryRepositoryTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Etsushi Otani on 2022/01/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
@testable import iOSEngineerCodeCheck
import XCTest

class GithubRepositoryRepositoryTests: XCTestCase {
    private var repositoryWithStub: GithubRepositoryRepository!
    private var repository: GithubRepositoryRepository!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        let stub = GithubAPIProviderStub()
        repositoryWithStub = GithubRepositoryRepository(provider: stub)
        let provider = GithubAPIProvider()
        repository = GithubRepositoryRepository(provider: provider)
    }

    /// searchRepositories()の単体テスト
    func testSearchRepositoriesWithStub() {
        let expectation = expectation(description: "testSearchRepositoryWithStub")

        repositoryWithStub.searchRepositories(by: "Alamofire")
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error): XCTFail(error.localizedDescription)
                case .finished: expectation.fulfill()
                }
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }

    /// searchRepositories()の結合テスト
    func testSearchRepositories() {
        let expectation = expectation(description: "testSearchRepository")

        repository.searchRepositories(by: "Alamofire")
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error): XCTFail(error.localizedDescription)
                case .finished: expectation.fulfill()
                }
            }, receiveValue: { response in
                XCTAssertNotNil(response)
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }
}

final class GithubAPIProviderStub: GithubAPIProviderProtocol {
    func exec<T>(with request: T) -> AnyPublisher<T.Response, Error> where T: Request, T.Response: Decodable, T.Response: Encodable {
        Future<T.Response, Error> { promise in
            let data = request.sampleData
            do {
                let result = try JSONDecoder().decode(T.Response.self, from: data)
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}