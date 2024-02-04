//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Irina Deeva on 27/01/24.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "Auth token")
        }
        set {
            guard let newValue else { return }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: "Auth token")
            guard isSuccess else { return }
        }
    }
    
    private init() { }
}
