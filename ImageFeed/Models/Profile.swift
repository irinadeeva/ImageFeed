//
//  Profile.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import Foundation

struct ProfileRespondResult: Decodable {
    let userName: String
    let firstName: String
    let lastName: String
    let bio: String?

    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}

struct Profile {
    let username: String
    let fullname: String
    let loginname: String
    let bio: String?

    init(profileResult: ProfileRespondResult) {
        self.username = profileResult.userName
        self.fullname = profileResult.firstName + " " + profileResult.lastName
        self.loginname = "@" + profileResult.userName
        self.bio = profileResult.bio
    }
}
