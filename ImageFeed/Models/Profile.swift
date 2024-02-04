//
//  Profile.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import Foundation

struct Profile {
    let username: String
    let fullname: String
    let loginname: String?
    let bio: String?

    init(profileResult: ProfileResultResponse) {
        self.username = profileResult.userName
        self.fullname = profileResult.firstName + " " + (profileResult.lastName ?? "")
        self.loginname = "@" + profileResult.userName
        self.bio = profileResult.bio
    }
}
