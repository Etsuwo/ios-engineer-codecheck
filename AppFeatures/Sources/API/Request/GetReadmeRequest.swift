//
//  GetReadmeRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/18.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Alamofire
import Foundation

public struct GetReadmeRequest: Request {
    public init(owner: String, repo: String) {
        self.owner = owner
        self.repo = repo
    }

    public typealias Response = GetReadmeResponse
    public var method: HTTPMethod = .get
    public var path: String {
        "/repos/\(owner)/\(repo)/readme"
    }

    public var owner: String
    public var repo: String
}

public extension GetReadmeRequest {
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "GetReadmeRequestSample", ofType: "json")!
        return try! String(contentsOfFile: path).data(using: .utf8)!
    }
}
