//
//  Item.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public struct Item: Codable {
    public var name: String
    public var fullName: String
    public var owner: Owner
    public var language: String?
    public var stargazersCount: Int
    public var watchersCount: Int
    public var forksCount: Int
    public var openIssuesCount: Int
    public var description: String?

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
