//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Irina Deeva on 07/02/24.
//

import Foundation

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }

    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol

    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    // MARK: - WebViewPresenterProtocol

    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {return}

        didUpdateProgressValue(0)
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(with: newProgressValue)

        let isHidden = abs(newProgressValue - 1) <= 0.0001
        view?.setProgressHidden(isHidden)
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
