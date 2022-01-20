//
//  SearchRepositoriesResponse.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

struct SearchRepositoriesResponse: Codable {
    var items: [Item]

    enum CodingKeys: String, CodingKey {
        case items
    }
}
