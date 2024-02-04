//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Irina Deeva on 01/02/24.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
