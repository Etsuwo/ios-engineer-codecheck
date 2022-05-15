//
//  APIError.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/16.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case noMoreContent
    case unknownError
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noMoreContent: return "わかりませーん"
        case .unknownError: return "知りませーん"
        }
    }
}
