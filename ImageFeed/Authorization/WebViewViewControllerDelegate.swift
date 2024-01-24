//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Irina Deeva on 23/01/24.
//

protocol WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
