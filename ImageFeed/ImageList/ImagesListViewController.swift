//
//  ViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 30/11/23.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
//    private let photoNames: [String] = Array(0..<20).map{ "\($0)" }
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
                let image = UIImage(named: photos[indexPath.row].largeImageURL)
                viewController.image = image
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
        guard let imageCell = UIImage(named: photos[indexPath.row].largeImageURL) else {
            return
        }
        cell.imageCell.image = imageCell

        cell.dataLabel.text =  dateFormatter.string(from: Date())

        let buttonImage = (indexPath.row % 2) == 0 ? UIImage(named: "Active") : UIImage(named: "No Active")

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
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photos[indexPath.row].largeImageURL) else {
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


