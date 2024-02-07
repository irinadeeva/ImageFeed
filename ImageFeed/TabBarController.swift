//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 03/02/24.
//

import UIKit

final class TabBarController: UITabBarController {

    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )

        let profileViewPresenter = ProfileViewPresenter()
        let profileViewController = ProfileViewController()
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)

        viewControllers = [imagesListViewController, profileViewController]
    }
}
