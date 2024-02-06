//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    static var isShowing: Bool = false

    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        isShowing = true
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        isShowing = false
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
