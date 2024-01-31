//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Irina Deeva on 28/01/24.
//

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
