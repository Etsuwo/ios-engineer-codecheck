//
//  Request.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Alamofire
import Foundation

public protocol Request {
    associatedtype Response
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameter: [String: Any]? { get }
    var encording: ParameterEncoding { get }
    var sampleData: Data { get } // テスト用
}

public extension Request {
    var baseURL: String { APIEndpoint.baseURL }
    var headers: HTTPHeaders { ["Content-Type": "application/vnd.github.v3+json"] }
    var parameter: [String: Any]? { nil }
    var encording: ParameterEncoding { URLEncoding.default }
}
