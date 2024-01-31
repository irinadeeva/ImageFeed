//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Irina Deeva on 31/01/24.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.dismiss()
    }
}
