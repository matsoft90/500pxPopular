//
//  NetworkService.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

protocol Requests {
    func asUrl() throws -> URL
    var params: [String: String] {get}
}

extension Requests {
    var params: [String: String] {
        return [:]
    }
}

protocol Service {
    @discardableResult
    func get(request: Requests, completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTask?
}

final class NetworkService: Service {
    func get(request: Requests, completion: @escaping (Result<Data>) -> Void) -> URLSessionDataTask? {
        // create data task
        do {
            var url = try request.asUrl()
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
                    return nil
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
            return task
        } catch {
            completion(.error(error))
        }
        return nil
    }
}

enum ServiceError: Error {
    case invalidParams
    case invalidData
}
