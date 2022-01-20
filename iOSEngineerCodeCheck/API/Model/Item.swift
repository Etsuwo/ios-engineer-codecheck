//
//  Item.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Item: Codable {
    var name: String
    var fullName: String
    var owner: Owner
    var language: String?
    var stargazersCount: Int
    var watchersCount: Int
    var forksCount: Int
    var openIssuesCount: Int
    var description: String?

    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case owner
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case description
    }
}
