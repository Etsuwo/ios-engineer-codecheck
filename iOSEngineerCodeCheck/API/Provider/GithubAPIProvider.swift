//
//  GithubAPIProvider.swift
//  iOSEngineerCodeCheck
//
//  Created by Etsushi Otani on 2022/01/17.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Alamofire
import Combine
import Foundation

protocol GithubAPIProviderProtocol {
    func exec<T: Request>(with request: T) -> AnyPublisher<T.Response, Error> where T.Response: Codable
}

final class GithubAPIProvider: GithubAPIProviderProtocol {
    /// API通信を実行する
    /// - Returns: Requestに対応するResponseを流すPublisher
    func exec<T: Request>(with request: T) -> AnyPublisher<T.Response, Error> where T.Response: Codable {
        Future<T.Response, Error> { [weak self] promise in
            self?.printForDebug(request: request)

            AF.request(request.baseURL + request.path, method: request.method, parameters: request.parameter, encoding: request.encording, headers: request.headers)
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
                        let result = try JSONDecoder().decode(T.Response.self, from: data)
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

    private func printForDebug<T: Request>(request: T) {
        debugPrint("path: " + request.baseURL + request.path)
        debugPrint("method: \(request.method)")
        debugPrint("parameter: \(String(describing: request.parameter))")
        debugPrint("headers: \(request.headers)")
    }
}
