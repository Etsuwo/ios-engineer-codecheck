//
//  Request.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/15.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Alamofire
import Combine
import Foundation

protocol Request {
    associatedtype Response
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders { get }
    var parameter: [String: Any]? { get }
    var encording: ParameterEncoding { get }
    func exec() -> AnyPublisher<Response, Error>
}

extension Request where Response: Codable {
    var baseURL: String { APIEndpoint.baseURL }
    var headers: HTTPHeaders { ["Content-Type": "application/vnd.github.v3+json"] }
    var parameter: [String: Any]? { nil }
    var encording: ParameterEncoding { URLEncoding.default }

    /// API通信を実行する
    func exec() -> AnyPublisher<Response, Error> {
        Future<Response, Error> { promise in
            debugPrint("path: " + baseURL + path)
            debugPrint("method: \(method)")
            debugPrint("parameter: \(String(describing: parameter))")
            debugPrint("headers: \(headers)")

            AF.request(baseURL + path, method: method, parameters: parameter, encoding: encording, headers: headers)
                .response { response in
                    if let error = response.error {
                        print(error.localizedDescription)
                        promise(.failure(error))
                        return
                    }
                    guard let data = response.data else {
                        promise(.failure(APIError.unknownError))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(Response.self, from: data)
                        print(result)
                        promise(.success(result))
                    } catch {
                        print(error.localizedDescription)
                        promise(.failure(error))
                    }
                }
        }
        .eraseToAnyPublisher()
    }
}
