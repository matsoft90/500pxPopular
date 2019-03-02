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
    
    /*
    {
    "upgrade_status": 0,
    "affection": 2042902,
    "store_on": true,
    "userpic_https_url": "https://drscdn.500px.org/user_avatar/23896/q%3D85_w%3D300_h%3D300/v2?webp=true&v=5&sig=59d154366279e1d2f1c56677ed023371049bc8db96af1b397f95a8fb4d9f678c",
    "cover_url": "https://drscdn.500px.org/user_cover/23896/q%3D65_m%3D2048/v2?webp=true&v=25&sig=4e2542eedd5b927e00bf088ede6462b62da55bbd6a2a8135b353a5c14b21628e",
    "usertype": 0,
    "userpic_url": "https://drscdn.500px.org/user_avatar/23896/q%3D85_w%3D300_h%3D300/v2?webp=true&v=5&sig=59d154366279e1d2f1c56677ed023371049bc8db96af1b397f95a8fb4d9f678c"
    }
    */
}
