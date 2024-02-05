//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by Irina Deeva on 04/02/24.
//

import Foundation

struct UrlsResultResponse: Decodable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL

    private enum CodingKeys: String, CodingKey {
        case raw = "raw"
        case full = "full"
        case regular = "regular"
        case small = "small"
        case thumb = "thumb"
    }
}
