//
//  Owner.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct Owner: Codable {
    var avatarUrl: String
    var login: String

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login
    }
}
