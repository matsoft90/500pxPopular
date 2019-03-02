//
//  Photo.swift
//  Popular
//
//  Created by Mahmood Tahir on 2019-03-02.
//  Copyright © 2019 Mahmood Tahir. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let images: [Image]
    let nsfw: Bool
    let imageUrl: [String]
    let votesCount: Int
    let description: String?
    let user: User
    
    private enum CodingKeys: String, CodingKey {
        case images
        case nsfw
        case imageUrl = "image_url"
        case votesCount = "votes_count"
        case description
        case user
    }
}
/*
{
    "voted": false,
    "editors_choice_date": null,
    "hi_res_uploaded": 0,
    "watermark": false,
    "latitude": null,
    "category": 18,
    "comments_count": 33,
    "camera": "ILCE-6500",
    "for_sale": false,
    "converted_bits": 0,
    "liked": false,
    "longitude": null,
    "positive_votes_count": 1428,
    "shutter_speed": "1/50",
    "image_format": "jpeg",
    "exclude_gads": false,
    "rating": 99.8,
    "user_id": 9650601,
    "aperture": "11",
    "collections_count": 38,
    "height": 1500,
    "comments": [],
    "converted": false,
    "iso": "100",
    "privacy": false,
    "sales_count": 0,
    "favorites_count": 0,
    "is_free_photo": false,
    "license_requests_enabled": true,
    "feature_date": "2019-02-28T19:09:20+00:00",
    "highest_rating": 99.8,
    "lens": "E 18-200mm F3.5-6.3 OSS",
    "taken_at": "2018-11-14T22:54:26-05:00",
    "for_critique": false,
    "name": "Sunburst",
    "for_sale_date": null,
    "disliked": false,
    "created_at": "2019-02-28T14:07:01-05:00",
    "editors_choice": false,
    "status": 1,
    "editored_by": {},
    "licensing_status": 0,
    "critiques_callout_dismissed": false,
    "request_to_buy_enabled": false,
    "licensing_requested": false,
    "highest_rating_date": "2019-03-01T10:34:48-05:00",
    "focal_length": "54",
    "width": 1000,
    "url": "/photo/296479753/sunburst-by-martin-podt",
    "licensing_suggested": false,
    "id": 296479753,
    "purchased": false,
    "profile": true,
    "location": null,
    "license_type": 0,
    "feature": "popular",
    "crop_version": 0,
    "times_viewed": 8820,
}*/
