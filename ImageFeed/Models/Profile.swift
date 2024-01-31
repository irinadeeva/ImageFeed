//
//  Profile.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import Foundation

struct Profile {
    let userName: String
    let fullName: String //конкатенация имени и фамилии пользователя (если first_name = "Ivan", last_name = "Ivanov", то name = "Ivan Ivanov")
    let loginName: String //username со знаком @ перед первым символом (если username = "ivanivanov", то loginName = "@ivanivanov")
    let bio: String
}
