//
//  SearchRepositoryRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Alamofire
import Foundation

public struct SearchRepositoriesRequest: Request {
    public init(searchWord: String, page: Int) {
        self.searchWord = searchWord
        self.page = page
    }

    public typealias Response = SearchRepositoriesResponse
    public var method: HTTPMethod = .get
    public var path: String = "/search/repositories"
    public var encording: ParameterEncoding = URLEncoding.queryString
    public var parameter: [String: Any]? {
        ["q": searchWord, "page": page]
    }

    var searchWord: String
    var page: Int
}

public extension SearchRepositoriesRequest {
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "SearchRepositoriesRequestSample", ofType: "json")!
        return try! String(contentsOfFile: path).data(using: .utf8)!
    }
}
