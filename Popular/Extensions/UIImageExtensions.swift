//
//  UIImageExtensions.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import UIKit

enum UIImageError: Error {
    case invalidData
}

struct ImageRequest: Requests {
    let url: URL
    
    func asUrl() throws -> URL {
        return url
    }
}

extension UIImage {
    /// Loads an UIImage from internet asynchronously
    @discardableResult
    static func asyncFrom(url: URL, service: Service = NetworkService(), _ completion: @escaping (Result<UIImage>) -> Void) -> URLSessionDataTask? {
        let task = service.get(request: ImageRequest(url: url)) { result in
            switch result {
            case .success(let data):
                asyncFrom(data: data, completion)
            case .error(let error):
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
        return task
    }
    
    private static func asyncFrom(data: Data, _ completion: @escaping (Result<UIImage>) -> Void) {
        DispatchQueue.global(qos: .default).async {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.error(UIImageError.invalidData))
                }
            }
        }
    }
}
