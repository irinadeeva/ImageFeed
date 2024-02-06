//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Irina Deeva on 13/12/23.
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImageListCell)
}

final class ImageListCell: UITableViewCell {
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var imageCell: UIImageView!
    static let reuseIdentifier = "ImageListCell"
    weak var delegate: ImageListCellDelegate?

    override func prepareForReuse() {
        super.prepareForReuse()

        imageCell.kf.cancelDownloadTask()
    }

    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(isLiked: Bool) {
        let buttonImage = isLiked == true ? UIImage(named: "Active") : UIImage(named: "No Active")

        self.favouriteButton.setImage(buttonImage, for: .normal)
    }

}
