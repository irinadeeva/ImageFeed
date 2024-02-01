//
//  Profile.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import Foundation

struct Profile {
    let userName: String
    let fullName: String
    let loginName: String
    let bio: String?

    init(profileResult: ProfileResult) {
        self.userName = profileResult.userName
        self.fullName = profileResult.firstName + " " + profileResult.lastName
        self.loginName = "@" + profileResult.userName
        self.bio = profileResult.bio
    }
}
