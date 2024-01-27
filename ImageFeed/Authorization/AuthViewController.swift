//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 22/01/24.
//
import UIKit

final class AuthViewController: UIViewController {
    private let oAuth2Service = OAuth2Service()
    private var tokenStorage = OAuth2TokenStorage()
    private let identifier = "ShowWebView"
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            guard let destinationViewController = segue.destination as? WebViewViewController else { fatalError("Failed to prepare for \(identifier)")
            }
            destinationViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        oAuth2Service.fetchAuthToken(code: code) { result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let data):
                    do {
                        let body = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                        print("this is a body \(body)")
                        tokenStorage.token = body.accessToken
                    } catch {
                        print(Error.self)
                    }
                case .failure(let error):
                    return
                }
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
