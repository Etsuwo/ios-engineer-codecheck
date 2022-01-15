//
//  Item.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Item: Codable {
    var fullName: String
    var owner: Owner
    var language: String?
    var stargazersCount: Int
    var watchersCount: Int
    var forksCount: Int
    var openIssuesCount: Int

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case owner
        case language
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

extension Item {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fullName = try container.decode(String.self, forKey: .fullName)
        owner = try container.decode(Owner.self, forKey: .owner)
        language = try container.decode(String?.self, forKey: .language)
        stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
        watchersCount = try container.decode(Int.self, forKey: .watchersCount)
        forksCount = try container.decode(Int.self, forKey: .forksCount)
        openIssuesCount = try container.decode(Int.self, forKey: .openIssuesCount)
    }
}
