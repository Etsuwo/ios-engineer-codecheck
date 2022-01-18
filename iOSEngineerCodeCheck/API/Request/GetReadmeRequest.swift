//
//  GetReadmeRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Alamofire
import Foundation

struct GetReadmeRequest: Request {
    typealias Response = GetReadmeResponse
    var method: HTTPMethod = .get
    var path: String {
        "/repos/\(owner)/\(repo)/readme"
    }

    var owner: String
    var repo: String
}

extension GetReadmeRequest {
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "GetReadmeRequestSample", ofType: "json")!
        return try! String(contentsOfFile: path).data(using: .utf8)!
    }
}
