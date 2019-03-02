//
//  PhotosResponse.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

struct PhotosResponse: Codable {
    struct Filter: Codable {
        let category: Bool
        let exclude: [Int]
    }
    let currentPage: Int
    let totalPages: Int
    let totalItems: Int
    let photos: [Photo]
    let feature: String
    let filters: Filter
    
    private enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case totalPages = "total_pages"
        case totalItems = "total_items"
        case photos
        case feature
        case filters
    }
}
