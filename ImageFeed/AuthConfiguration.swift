//
//  Constants.swift
//  ImageFeed
//
//  Created by Irina Deeva on 21/01/24.
//

let AccessKey = "2tX1X08-JggmSw4V92uvSMNzkLgI4UNUSeY4aWu0h_g"
let SecretKey = "rfvwjpGquA2M34ncqNBZZLEkvcVhM3oq5joNw2ZQzFA"
let RedirectUR = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let UnsplashDefaultBaseURL = "https://api.unsplash.com/"
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let UnsplashTokenURLString = "https://unsplash.com/oauth/token"
let TokenKeychainWrapperKey = "Auth token"

import Foundation
struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectUR: String
    let accessScope: String
    let unsplashDefaultBaseURL: String
    let unsplashAuthorizeURLString: String
    let unsplashTokenURLString: String
    let tokenKeychainWrapperKey: String

    init(accessKey: String, secretKey: String, redirectUR: String, accessScope: String, unsplashDefaultBaseURL: String, unsplashAuthorizeURLString: String, unsplashTokenURLString: String, tokenKeychainWrapperKey: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectUR = redirectUR
        self.accessScope = accessScope
        self.unsplashDefaultBaseURL = unsplashDefaultBaseURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.unsplashTokenURLString = unsplashTokenURLString
        self.tokenKeychainWrapperKey = tokenKeychainWrapperKey
    }

    static var standard: AuthConfiguration {
            return AuthConfiguration(accessKey: AccessKey,
                                     secretKey: SecretKey,
                                     redirectUR: RedirectUR,
                                     accessScope: AccessScope,
                                     unsplashDefaultBaseURL: UnsplashDefaultBaseURL,
                                     unsplashAuthorizeURLString: UnsplashAuthorizeURLString,
                                     unsplashTokenURLString: UnsplashTokenURLString,
                                     tokenKeychainWrapperKey: TokenKeychainWrapperKey)
        }
}
