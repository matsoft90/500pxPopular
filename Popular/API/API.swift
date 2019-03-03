//
//  API.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

class API {
    let service: Service
    /// Shared configuration for all services. Contains params for all services
    fileprivate static let config: [String: String]? = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"), let config = NSDictionary(contentsOfFile: path) else {
            return nil
        }
        return config as? [String: String]
    }()
    convenience init() {
        self.init(service: NetworkService())
    }
    
    init(service: Service) {
        self.service = service
    }
    
    func popularPhotos(page: Int = 1, _ completion: @escaping (Result<PhotosResponse>) -> Void) {
        service.get(request: APIRequests.popular(page)) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.dateTime)
                    let resp = try decoder.decode(PhotosResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(resp))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.error(error))
                    }
                }
            case .error(let error):
                DispatchQueue.main.async {
                    completion(.error(error))
                }
            }
        }
    }
}

enum APIRequests: Requests {
    case popular(Int)
    
    var params: [String : String] {
        var params = [String: String]()
        if let config = API.config {
            for (key, value) in config {
                params[key] = value
            }
        }
        switch self {
        case .popular(let page):
            params["page"] = "\(page)"
            params["image_size"] = "31,2048"
            return params
        }
    }
    func asUrl() throws -> URL {
        switch self {
        case .popular:
            if let url = URL(string: Constants.apiBaseUrl + Constants.Endpoints.photos) {
                return url
            }
        }
        
        throw APIError.invalidParams
    }
}

enum APIError: Error {
    case noQuestions
    case invalidParams
}

extension String {
    var urlQueryEncoded: String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
