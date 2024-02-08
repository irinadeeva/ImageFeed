//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Irina Deeva on 08/02/24.
//

@testable import ImageFeed
import XCTest

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func logOut() {
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewPresenterProtocol?
    var shouldUpdateProfile: Bool = false
    var shouldUpdateAvatar: Bool = false

    func updateProfileDetails(profile: ImageFeed.Profile) {
        shouldUpdateProfile = true
    }
    
    func updateAvatar(with url: URL) {
        shouldUpdateAvatar = true
    }
}

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallViewDidLoad() {
        // given
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewController()
        viewController.presenter = presenter
        presenter.view = viewController

        // when
        _ = viewController.viewDidLoad()

        // then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterNotCallsUpdateProfileDetails() {
        // given
        let presenter = ProfileViewPresenter(cookiesCleaner: CookiesCleaner())
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter

        // when
        presenter.viewDidLoad()

        // then
        XCTAssertFalse(viewController.shouldUpdateProfile)
    }

    func testPresenterNotCallsUpdateProfileAvatar() {
        // given
        let presenter = ProfileViewPresenter(cookiesCleaner: CookiesCleaner())
        let viewController = ProfileViewControllerSpy()
        presenter.view = viewController
        viewController.presenter = presenter

        // when
        presenter.viewDidLoad()

        // then
        XCTAssertFalse(viewController.shouldUpdateAvatar)
    }

    func testPresenterCallsUpdateProfileDetails() {
        // given
        let viewController = ProfileViewControllerSpy()
        let profileResult = ProfileResultResponse(userName: "", firstName: "", lastName: "", bio: "")
        let profile = Profile(profileResult: profileResult)

        // when
        viewController.updateProfileDetails(profile: profile)

        // then
        XCTAssertFalse(viewController.shouldUpdateProfile)
    }

    func testPresenterCallsUpdateAvatar() {
        // given
        let viewController = ProfileViewControllerSpy()
        guard let url = URL(string: "") else { return }

        // when
        viewController.updateAvatar(with: url)

        // then
        XCTAssertFalse(viewController.shouldUpdateAvatar)
    }

    func testCookiesCleaner() {
        // given
        let cookiesCleaner = CookiesCleaner()
        let presenter = ProfileViewPresenter(cookiesCleaner: cookiesCleaner)

        // when
        presenter.logOut()

        // then
        XCTAssertEqual(HTTPCookieStorage.shared.cookies?.isEmpty, true)
        XCTAssertNil(OAuth2TokenStorage.shared.token)
    }
}
