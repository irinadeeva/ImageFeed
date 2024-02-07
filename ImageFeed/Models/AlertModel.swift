//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Irina Deeva on 01/02/24.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonTexts: [String]
    let completion: (_ index: Int) -> Void
}
