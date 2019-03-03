//
//  Photo.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let images: [Image]
    let nsfw: Bool
    let imageUrl: [URL]
    let votesCount: Int
    let commentsCount: Int
    let description: String?
    let user: User
    let rating: Double
    let camera: String?
    let iso: String?
    let takenAt: Date?
    let createdAt: Date?
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case images
        case nsfw
        case imageUrl = "image_url"
        case votesCount = "votes_count"
        case commentsCount = "comments_count"
        case description
        case user
        case rating
        case camera
        case iso
        case takenAt = "taken_at"
        case createdAt = "created_at"
        case name
    }
}
