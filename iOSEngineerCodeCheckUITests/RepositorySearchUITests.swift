//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class RepositorySearchUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app.terminate()
    }

    /// 検索結果が正常に表示されるかテスト
    func testSearchRepository() {
        _ = app.waitForExistence(timeout: 5)

        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("Alamofire")

        app.buttons["Done"].tap()

        let cell = app.tables.firstMatch.children(matching: .cell).firstMatch.waitForExistence(timeout: 10)
        XCTAssertTrue(cell)
    }
    
    /// 検索結果ゼロ画面が表示されるかテスト
    func testRepositoryNotFound() {
        _ = app.waitForExistence(timeout: 5)

        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("hfushablbekbafhlebhfla")

        app.buttons["Done"].tap()

        let isExistNotFoundImage = app.images.matching(identifier: "repositoryNotFoundView").firstMatch.waitForExistence(timeout: 10)
        XCTAssertTrue(isExistNotFoundImage)
    }

    /// 通信エラー画面が表示されるかテスト
    func testErrorView() {
        _ = app.waitForExistence(timeout: 5)

        let searchBar = app.searchFields.firstMatch
        searchBar.tap()
        searchBar.typeText("　　　")

        app.buttons["Done"].tap()

        let isExistNotFoundImage = app.images.matching(identifier: "reloadableErrorView").firstMatch.waitForExistence(timeout: 10)
        XCTAssertTrue(isExistNotFoundImage)
    }
}
