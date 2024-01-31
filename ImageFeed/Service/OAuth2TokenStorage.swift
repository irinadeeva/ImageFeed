//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Irina Deeva on 27/01/24.
//

import Foundation

class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    private let userDefaults = UserDefaults.standard
    var token: String? {
        get {
            return userDefaults.string(forKey: "OAuth2Token")
        }
        set {
            userDefaults.set(newValue, forKey: "OAuth2Token")
        }
    }
    
    private init() { }
}
