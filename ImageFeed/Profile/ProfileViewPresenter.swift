//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Irina Deeva on 07/02/24.
//

import UIKit

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logOut()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var cookiesCleaner: CookiesCleanerProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let tokenStorage = OAuth2TokenStorage.shared

    init(cookiesCleaner: CookiesCleanerProtocol) {
        self.cookiesCleaner = cookiesCleaner
    }

    func viewDidLoad() {
        if let profile = profileService.profile {
            view?.updateProfileDetails(profile: profile)
        }

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self,
                    let profileImageURL = profileImageService.avatarURL,
                    let url = URL(string: profileImageURL)
                else { return }

                view?.updateAvatar(with: url)
            }
        
        if let profileImageURL = profileImageService.avatarURL,
           let url = URL(string: profileImageURL) {
            view?.updateAvatar(with: url)
        }

    }

    func logOut() {
        cookiesCleaner.clean()
        tokenStorage.clearToken()
        UIApplication.shared.windows.first?.rootViewController = SplashViewController()
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

//import WebKit
//
//extension ProfileViewPresenter {
//    private func clean() {
//        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
//        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
//            records.forEach { record in
//                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
//            }
//        }
//    }
//}
