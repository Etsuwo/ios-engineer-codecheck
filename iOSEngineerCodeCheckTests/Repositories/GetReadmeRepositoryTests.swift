//
//  GetReadmeRepositoryTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by Etsushi Otani on 2022/01/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Combine
@testable import iOSEngineerCodeCheck
import XCTest

class GetReadmeRepositoryTests: XCTestCase {
    private var repositoryWithStub: GetReadmeRepository!
    private var repository: GetReadmeRepository!
    private var cancellables = Set<AnyCancellable>()

    override func setUp() {
        let stub = GithubAPIProviderStub()
        repositoryWithStub = GetReadmeRepository(provider: stub)
        let provider = GithubAPIProvider()
        repository = GetReadmeRepository(provider: provider)
    }

    /// getReadme()の単体テスト
    func testGetReadmeWithStub() {
        let expectation = expectation(description: "testGetReadmeWithStub")

        repositoryWithStub.readme
            .sink(receiveValue: { response in
                XCTAssertNotNil(response)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        repositoryWithStub.getReadme(owner: "Etsuwo", repository: "Etsuwo")

        waitForExpectations(timeout: 5, handler: nil)
    }

    /// getReadme()の結合テスト
    func testGetReadme() {
        let expectation = expectation(description: "testGetReadme")

        repository.readme
            .sink(receiveValue: { response in
                XCTAssertNotNil(response)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        repository.getReadme(owner: "Etsuwo", repository: "Etsuwo")

        waitForExpectations(timeout: 5, handler: nil)
    }
}
