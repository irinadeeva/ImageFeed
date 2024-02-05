//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Irina Deeva on 13/12/23.
//

import UIKit
import Kingfisher

final class ImageListCell: UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var imageCell: UIImageView!
    static let reuseIdentifier = "ImageListCell"

    override func prepareForReuse() {
        super.prepareForReuse()

        imageCell.kf.cancelDownloadTask()
    }
}
