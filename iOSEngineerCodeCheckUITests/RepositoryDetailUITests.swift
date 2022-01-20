//
//  RepositoryDetailUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by Etsushi Otani on 2022/01/20.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest

class RepositoryDetailUITests: XCTestCase {
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

    /// 詳細画面に遷移して画面(アバター画像)が表示されることを確認するテスト
    func testTransitionDetail() {
        XCTContext.runActivity(named: "検索画面でcell表示") { _ in
            _ = app.waitForExistence(timeout: 5)

            let searchBar = app.searchFields.firstMatch
            searchBar.tap()
            searchBar.typeText("Alamofire")

            app.buttons["Done"].tap()

            let isExistCell = app.tables.firstMatch.children(matching: .cell).firstMatch.waitForExistence(timeout: 10)
            XCTAssertTrue(isExistCell)
        }

        XCTContext.runActivity(named: "cellタップして詳細画面表示") { _ in
            app.tables.firstMatch.children(matching: .cell).firstMatch.tap()

            let isExistImage = app.images.firstMatch.waitForExistence(timeout: 5)

            XCTAssertTrue(isExistImage)
        }
    }
}
