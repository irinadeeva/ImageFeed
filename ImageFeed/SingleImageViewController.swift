//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 30/12/23.
//

import Foundation
import UIKit

class SingleImageViewController: UIViewController {
    var image: UIImage!
    
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
}
