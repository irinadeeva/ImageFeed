//
//  ViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 30/11/23.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        imagesListService.fetchPhotosNextPage()

        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == showSingleImageSegueIdentifier {
                if let viewController = segue.destination as? SingleImageViewController,
                   let indexPath = sender as? IndexPath {
                    // mistake that largeImageURL is not in a cache !!!! so I need to download it
                    // поменять заклушку 
                    if let image = getCachedImage(by: photos[indexPath.row].largeImageURL) {
                        viewController.image = image
                    }
                }
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }

    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count

        if oldCount != newCount {
            photos = imagesListService.photos
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }

    private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]

        guard let imageURL = URL(string: photo.thumbImageURL) else {
            return
        }

        _ = RoundCornerImageProcessor(cornerRadius: 16)
        let placeholder = UIImage(named: "Photo Stub")

        cell.imageCell.kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: [.cacheMemoryOnly]
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }

        }

        cell.dataLabel.text =  dateFormatter.string(from: photo.createdAt ?? Date())

        let buttonImage = (photo.isLiked) == true ? UIImage(named: "Active") : UIImage(named: "No Active")

        cell.favouriteButton.setImage(buttonImage, for: .normal)
    }
}

extension ImagesListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
//            //debug
//            imagesListService.changeLike(photoId: photos[0].id, isLike: true) {_ in
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)

        if indexPath.row == 0 {
            imagesListService.changeLike(photoId: photos[indexPath.row].id, isLike: true) {_ in
            }
        }
        return imageListCell
    }

    private func getCachedImage(by url: String) -> UIImage? {
        guard let imageURL = URL(string: url) else {
            return nil
        }

        guard var image = UIImage(named: "Photo Stub") else {
            return nil
        }

        KingfisherManager.shared.retrieveImage(with: imageURL) { result in
            switch result {
                case .success(let value):
//                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    image = value.image
                case .failure(let error):
                    print("Error: \(error)")
                }
        }

        return image
    }
}

extension ImagesListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]

        guard let image = getCachedImage(by: photo.thumbImageURL) else {
            return 0
        }

        let imageInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        let imageWidth = image.size.width
        let imageHeight = image.size.height

        let requiredWidth = tableView.bounds.width - imageInsets.left - imageInsets.right

        let widthRatio = requiredWidth / imageWidth

        let requiredHeight = imageHeight * widthRatio + imageInsets.top + imageInsets.bottom

        return requiredHeight
    }
}


