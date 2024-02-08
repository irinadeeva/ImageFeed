//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Irina Deeva on 08/02/24.
//
@testable import ImageFeed
import XCTest


final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var view: ImageFeed.WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func didUpdateProgressValue(_ newValue: Double) {
    }

    func code(from url: URL) -> String? {
        return nil
    }
}


final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var loadCalled: Bool = false
    var shouldHide: Bool = false

    func load(request: URLRequest) {
        loadCalled = true
    }

    func setProgressValue(with newValue: Float) {
    }

    func setProgressHidden(_ isHidden: Bool) {
        shouldHide = isHidden
    }
}

final class WebViewTests: XCTestCase {

    func testViewControllerCallViewDidLoad() {
        // given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewController = storyboard.instantiateViewController(identifier: "WebViewViewController")
        as? WebViewViewController
        if let webViewController = webViewController {
            let webViewPresenter = WebViewPresenterSpy()
            webViewController.presenter = webViewPresenter
            webViewPresenter.view = webViewController

            // when
            _ = webViewController.view


            // then
            XCTAssertTrue(webViewPresenter.viewDidLoadCalled)
        }
    }

    func testPresenterCallsLoadRequest() {
        // given
        let webViewController = WebViewViewControllerSpy()
        let webViewPresenter = WebViewPresenter(authHelper: AuthHelper())
        webViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewController

        // when
        webViewPresenter.viewDidLoad()


        // then
        XCTAssertTrue(webViewController.loadCalled)
    }

    func testProgressVisibleWhenLessThenOne() {
        // given
        let webViewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        webViewController.presenter = presenter
        presenter.view = webViewController
        let progress: Double = 0.6

        // when
        presenter.didUpdateProgressValue(progress)

        // then
        XCTAssertFalse(webViewController.shouldHide)
    }

    func testProgressVisibleWhenOne() {
        // given
        let webViewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        webViewController.presenter = presenter
        presenter.view = webViewController
        let progress: Double = 1.0

        // when
        presenter.didUpdateProgressValue(progress)

        // then
        XCTAssertTrue(webViewController.shouldHide)
    }

    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)

        // when
        if let urlRequest = authHelper.authRequest() {
            guard let url = urlRequest.url else { return }
            let urlString = url.absoluteString

            // then
            XCTAssertTrue(urlString.contains(configuration.unsplashAuthorizeURLString))
            XCTAssertTrue(urlString.contains(configuration.accessKey))
            XCTAssertTrue(urlString.contains(configuration.redirectUR))
            XCTAssertTrue(urlString.contains("code"))
            XCTAssertTrue(urlString.contains(configuration.accessScope))

        }
    }

    func testCodeFromURL() {
        // given
        let authHelper = AuthHelper()
        let path = "https://unsplash.com/oauth/authorize/native"
        guard var urlComponents = URLComponents(string: path) else { return }
        let queryItem = [URLQueryItem(name: "code", value: "test code")]
        urlComponents.queryItems = queryItem
        guard let url = urlComponents.url else { return }

        // when
        let token = authHelper.code(from: url)

        // then
        XCTAssertEqual(token, "test code")
    }
}
