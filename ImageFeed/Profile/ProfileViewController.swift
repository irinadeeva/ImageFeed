////
////  File.swift
////  ImageFeed
////
////  Created by Irina Deeva on 29/12/23.
////

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var profileImage: UIImageView!
    private var userName: UILabel!
    private var userNickname: UILabel!
    private var userDescription: UILabel!
    private var logoutButton: UIButton!
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        
        setupProfileImage()
        setupUserNameLabel()
        setupUserNicknameLabel()
        setupUserDescriptionLabel()
        setupLogoutButton()
        setupConstraints()

        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }

    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }

        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        let placeholder = UIImage(named: "YP Stub")

        profileImage.kf.indicatorType = .activity

        profileImage.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.processor(processor),
                      .cacheMemoryOnly
                     ]
        )
    }

    private func updateProfileDetails(profile: Profile) {
        userName.text = profile.fullname
        userNickname.text = profile.loginname
        if let bio = profile.bio {
            userDescription.text = bio
        }
    }

    private func setupProfileImage() {
        profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
    }

    private func setupUserNameLabel() {
        userName = UILabel()
        userName.textColor = .ypWhite
        userName.font = .systemFont(ofSize: 23, weight: .semibold)
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
    }

    private func setupUserNicknameLabel() {
        userNickname = UILabel()
        userNickname.textColor = .ypGrey
        userNickname.font = .systemFont(ofSize: 13)
        userNickname.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNickname)
    }

    private func setupUserDescriptionLabel() {
        userDescription = UILabel()
        userDescription.textColor = .ypWhite
        userDescription.font = .systemFont(ofSize: 13)
        userDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userDescription)
    }

    private func setupLogoutButton() {
        logoutButton = UIButton.systemButton(
            with: UIImage(named: "Exit") ?? UIImage(),
            target: self,
            action: #selector(tapLogoutButton)
        )
        logoutButton.tintColor = .ypRed
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            logoutButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            userName.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            userName.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            userNickname.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 8),
            userNickname.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            userDescription.topAnchor.constraint(equalTo: userNickname.bottomAnchor, constant: 8),
            userDescription.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor)
        ])
    }

    @objc
    private func tapLogoutButton() {
    }
}
