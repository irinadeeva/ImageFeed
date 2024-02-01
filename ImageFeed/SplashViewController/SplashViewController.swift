//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 27/01/24.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    private let oAuth2Service = OAuth2Service.shared
    private var tokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = tokenStorage.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenIdentifier, sender: nil)
        }
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }

        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")

        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenIdentifier {
            guard
                let destinationViewController = segue.destination as? UINavigationController,
                let viewController = destinationViewController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenIdentifier)")
                return
            }

            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
            UIBlockingProgressHUD.dismiss()
        }

    }

    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                self.tokenStorage.token = token
                self.fetchProfile(token)
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                // TODO: [Sprint 11] Показать ошибку
            }
        }
    }

    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profile):
                profileService.updateProfile(profile)
                if let profile = profileService.profile {
                    fetchProfileImageURL(for: profile.username)
//                    print(profileImageService.avatarURL)
                }

//                DispatchQueue.main.async {
//                    self.switchToTabBarController()
//                    UIBlockingProgressHUD.dismiss()
//                }
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                // TODO: [Sprint 11] Показать ошибку
//                DispatchQueue.main.async {
//                    UIBlockingProgressHUD.dismiss()
//                    // TODO: [Sprint 11] Показать ошибку
//                }
            }
        }
    }

    private func fetchProfileImageURL(for username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageURL):
                profileImageService.updateImageProfile(with: imageURL)

                DispatchQueue.main.async {
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(_):

                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    // TODO: [Sprint 11] Показать ошибку
                }

            }
        }
    }
}
