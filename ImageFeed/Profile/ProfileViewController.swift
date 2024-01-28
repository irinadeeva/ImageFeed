////
////  File.swift
////  ImageFeed
////
////  Created by Irina Deeva on 29/12/23.
////

import UIKit

final class ProfileViewController: UIViewController {
    private var profileImage: UIImageView!
    private var userName: UILabel!
    private var userNickname: UILabel!
    private var userDescription: UILabel!
    private var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfileImage()
        setupUserNameLabel()
        setupUserNicknameLabel()
        setupUserDescriptionLabel()
        setupLogoutButton()
        
        setupConstraints()
    }

    private func setupProfileImage() {
        profileImage = UIImageView()
        profileImage.image = UIImage(named: "Photo") ?? UIImage(named: "Stub")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImage)
    }
    
    private func setupUserNameLabel() {
        userName = UILabel()
        userName.text = "Екатерина Новикова"
        userName.textColor = .ypWhite
        userName.font = .systemFont(ofSize: 23, weight: .semibold)
        userName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userName)
    }
    
    private func setupUserNicknameLabel() {
        userNickname = UILabel()
        userNickname.text = "@ekaterina_nov"
        userNickname.textColor = .ypGrey
        userNickname.font = .systemFont(ofSize: 13)
        userNickname.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userNickname)
    }
    
    private func setupUserDescriptionLabel() {
        userDescription = UILabel()
        userDescription.text = "Hello, world!"
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
