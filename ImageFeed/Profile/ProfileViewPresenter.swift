//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Irina Deeva on 07/02/24.
//

import Foundation


protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    

    
}
