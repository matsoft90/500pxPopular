//
//  NetworkService.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

protocol Requests {
    func url() throws -> URL
    var params: [String: String] {get}
}

protocol Service {
    func get(request: Requests, completion: @escaping (Result<Data>) -> Void)
}

final class NetworkService: Service {
    func get(request: Requests, completion: @escaping (Result<Data>) -> Void) {
        // create data task
        do {
            var url = try request.url()
            let params = request.params
            // append params
            if params.count > 0 {
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                var queryItems = components?.queryItems ?? [URLQueryItem]()
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
                components?.queryItems = queryItems
                // recreate the url
                guard let reconstructedUrl = components?.url else {
                    completion(.error(ServiceError.invalidParams))
                    return
                }
                url = reconstructedUrl
            }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.error(error))
                    return
                }
                guard let data = data else {
                    completion(.error(ServiceError.invalidData))
                    return
                }
                completion(.success(data))
            }
            task.resume()
        } catch {
            completion(.error(error))
        }
    }
}

enum ServiceError: Error {
    case invalidParams
    case invalidData
}
