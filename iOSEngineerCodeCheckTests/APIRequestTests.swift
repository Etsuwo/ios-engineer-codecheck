//
//  iOSEngineerCodeCheckTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Combine
@testable import iOSEngineerCodeCheck
import XCTest

class APIRequestTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    let provider = GithubAPIProvider()

    func testSearchRepositoryRequest() {
        let expectation = expectation(description: "testSearchRepositoryRequest")
        let request = SearchRepositoriesRequest(searchWord: "Alamofire")

        provider.exec(with: request)
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
