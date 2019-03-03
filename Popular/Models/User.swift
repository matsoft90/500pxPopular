//
//  User.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

struct ImageUrl: Codable {
    let url: URL
    
    private enum CodingKeys: String, CodingKey {
        case url = "https"
    }
}
struct Avatars: Codable {
    let `default`: ImageUrl
    let tiny: ImageUrl
    let small: ImageUrl
    let large: ImageUrl
}

struct User: Codable {
    let id: Int
    let fullName: String?
    let city: String?
    let username: String?
    let firstName: String?
    let lastName: String?
    let avatars: Avatars?
    let country: String?
    private enum CodingKeys: String, CodingKey {
        case id
        case fullName = "fullname"
        case city
        case username
        case firstName = "firstname"
        case lastName = "lastname"
        case avatars
        case country
    }
}
