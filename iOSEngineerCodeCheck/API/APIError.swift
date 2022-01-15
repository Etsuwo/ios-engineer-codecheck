//
//  APIError.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unknownError
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknownError: return L10n.Error.Unknown.description
        }
    }
}
