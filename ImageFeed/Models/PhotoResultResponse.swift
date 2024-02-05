//
//  PhotoResultResponse.swift
//  ImageFeed
//
//  Created by Irina Deeva on 04/02/24.
//

import Foundation

struct PhotoResultResponse: Decodable {
    let id: String
    let width: Int // i dont know if it is okey to say it a double
    let height: Int // i dont know if it is okey to say it a double
    let createdAtString: String? // i dont know if it is okey to say it a string
    let welcomeDescription: String?
    let urls: UrlsResultResponse
    let isLiked: Bool

   private enum CodingKeys: String, CodingKey {
       case id = "id"
       case width = "width"
       case height = "height"
       case createdAtString = "created_at"
       case welcomeDescription = "description"
       case urls =  "urls"
       case isLiked = "liked_by_user"
    }
}


