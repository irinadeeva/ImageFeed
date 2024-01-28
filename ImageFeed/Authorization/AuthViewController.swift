//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 22/01/24.
//
import UIKit

final class AuthViewController: UIViewController {
    private let identifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    
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
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
