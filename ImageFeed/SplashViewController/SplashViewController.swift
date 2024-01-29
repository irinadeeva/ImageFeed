//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 27/01/24.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    private let oAuth2Service = OAuth2Service()
    private var tokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (tokenStorage.token != nil) {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthenticationScreenIdentifier, sender: nil)
        }
    }
        
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
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
                fatalError("Failed to prepare for \(showAuthenticationScreenIdentifier)")
            }
            
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code: code) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let data):
                    do {
                        let body = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        tokenStorage.token = body.accessToken
                    } catch {
                        print(Error.self)
                    }
                    switchToTabBarController()
                case .failure(_):
                    return
                }
            }
        }
    }
    
}
