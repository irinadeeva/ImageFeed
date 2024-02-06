//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 22/01/24.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self

        estimatedProgressObservation = webView.observe(
             \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 self.updateProgress()
             })

        guard let request = authorisationRequest() else {return}

        webView.load(request)
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1) <= 0.0001
    }

    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            self.delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

extension WebViewViewController {
    func authorisationRequest() -> URLRequest? {
        return URLRequest.buildRequest(
            path: Constants.unsplashAuthorizeURLString,
            queryItems: [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectUR),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: Constants.accessScope)
        ])
    }
}
