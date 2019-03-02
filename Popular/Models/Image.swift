//
//  Image.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

/// Represents a 500px image object
struct Image: Codable {
    let httpsUrl: URL
    let format: String
    let size: Size
    let url: URL
    
    private enum CodingKeys: String, CodingKey {
        case httpsUrl = "https_url"
        case format
        case size
        case url
    }
}

extension Image {
    /// Image size
    ///
    /// - square70: 70x70
    /// - square140: 140x140
    /// - square280: 280x280
    /// - square100: 100x100
    /// - square200: 200x200
    /// - square440: 440x440
    /// - square600: 600x600
    /// - longestEdge900: 900 on the longest edge
    /// - longestEdge1170: 1170 on the longest edge
    /// - longestEdge256: 256 on the longest edge
    /// - longestEdge1080: 1080 on the longest edge
    /// - longestEdge1600: 1600 on the longest edge
    /// - longestEdge2048: 2048 on the longest edge
    /// - high1080: height of 1080
    /// - high300: height of 300
    /// - high600: height of 600
    /// - high450: height of 450
    enum Size: Int, Codable {
        // square
        case square70 = 1
        case square140 = 2
        case square280 = 3
        case square100 = 100
        case square200 = 200
        case square440 = 440
        case square600 = 600
        // longest edge
        case longestEdge900 = 4
        case longestEdge1170 = 5
        case longestEdge256 = 30
        case longestEdge1080 = 1080
        case longestEdge1600 = 1600
        case longestEdge2048 = 2048
        // hight
        case high1080 = 6
        case high300 = 20
        case high600 = 21
        case high450 = 31
    }
    enum Category: Int, Codable {
        case uncategorized = 0
        case celebrities
        case film
        case journalism
        case nude
        case blackAndWhite
        case stillLife
        case people
        case landscapes
        case cityAndArchitecture
        case abstract
        case animals
        case macro
        case travel
        case fashion
        case commercial
        case concert
        case sport
        case nature
        case performingArts
        case family
        case street
        case underwater
        case food
        case fineArt
        case wedding
        case transportation
        case urbanExploration
        case aerial = 29
        case night = 30
    }
}
