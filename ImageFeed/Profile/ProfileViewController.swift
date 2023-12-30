//
//  File.swift
//  ImageFeed
//
//  Created by Irina Deeva on 29/12/23.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var userNickname: UILabel!
    @IBOutlet private var userDescription: UILabel!
    @IBOutlet private var logoutButton: UIButton!
    
    @IBAction private func didTapLogoutButton(_ sender: Any) {
    }
}
