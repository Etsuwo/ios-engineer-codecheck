//
//  SearchRepositoryRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Alamofire
import Foundation

struct SearchRepositoriesRequest: Request {
    typealias Response = SearchRepositoriesResponse
    var method: HTTPMethod = .get
    var path: String = "/search/repositories"
    var encording: ParameterEncoding = URLEncoding.queryString
    var parameter: [String: Any]? {
        ["q": searchWord]
    }

    var searchWord: String
}

extension SearchRepositoriesRequest {
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "SearchRepositoriesRequestSample", ofType: "json")!
        return try! String(contentsOfFile: path).data(using: .utf8)!
    }
}
