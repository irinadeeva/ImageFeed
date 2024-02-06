//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 27/01/24.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private var launchImage: UIImageView!
    private let showAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    private let oAuth2Service = OAuth2Service.shared
    private var tokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter: AlertProtocol?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = .ypBlack
        setupImage()
        alertPresenter = AlertPresenter(viewController: self)

        guard UIBlockingProgressHUD.isShowing == false else { return }
        if let token = tokenStorage.token {
            fetchProfile(token)
        } else {
            showAuthenticationScreen()
        }
    }

    private func showAuthenticationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let authViewController = storyboard.instantiateViewController(withIdentifier: showAuthenticationScreenIdentifier)
            as? AuthViewController {
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(
                authViewController,
                animated: true,
                completion: nil
            )
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

    private func showAlertNetworkError() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonTexts: ["OK"]
        ) { [weak self] index in
            guard let self else {return}

            if  let token = tokenStorage.token {
                fetchProfile(token)
            } else {
                showAuthenticationScreen()
            }
        }

        alertPresenter?.show(alertModel: alert)
    }

    private func setupImage() {
        launchImage = UIImageView()
        launchImage.image = UIImage(named: "Vector")
        launchImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(launchImage)

        launchImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        launchImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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
            case .failure:
                showAlertNetworkError()
                UIBlockingProgressHUD.dismiss()
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
                }
                UIBlockingProgressHUD.dismiss()
            case .failure:
                showAlertNetworkError()
                UIBlockingProgressHUD.dismiss()
            }
        }
    }

    private func fetchProfileImageURL(for username: String) {
        profileImageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let imageURL):
                profileImageService.updateImageProfile(with: imageURL)

                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": imageURL])

                DispatchQueue.main.async {
                    self.switchToTabBarController()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.showAlertNetworkError()
                    UIBlockingProgressHUD.dismiss()
                }

            }
        }
    }
}
