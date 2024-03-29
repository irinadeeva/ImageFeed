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
    private var alertPresenter: AlertProtocol?

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter = AlertPresenter(viewController: self)

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
                guard let self else { return }
                self.updateTableViewAnimated()
            }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            if let viewController = segue.destination as? SingleImageViewController,
               let indexPath = sender as? IndexPath {
                viewController.imageURL = URL(string: photos[indexPath.row].largeImageURL)
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

        guard let imageURL = URL(string: photo.thumbImageURL) else { return }

        _ = RoundCornerImageProcessor(cornerRadius: 16)
        let placeholder = UIImage(named: "Photo Stub")

        cell.imageCell.kf.setImage(with: imageURL,
                                   placeholder: placeholder,
                                   options: [.cacheMemoryOnly]) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure:
                self.showAlertNetworkError()
            }

        }

        if let createdAt = photo.createdAt {
            cell.dataLabel.text = dateFormatter.string(from: createdAt)
        } else {
            cell.dataLabel.text = ""
        }

        cell.setIsLiked(isLiked: photo.isLiked)
    }
}

extension ImagesListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            DispatchQueue.global().async { [weak self] in
                self?.imagesListService.fetchPhotosNextPage() 
            }
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)

        imageListCell.delegate = self

        return imageListCell
    }

    private func getCachedImage(by url: String) -> UIImage? {
        guard let imageURL = URL(string: url) else {
            return nil
        }

        guard var image = UIImage(named: "Photo Stub") else {
            return nil
        }

        KingfisherManager.shared.retrieveImage(with: imageURL) { [weak self] result in
            switch result {
            case .success(let value):
                image = value.image
            case .failure:
                self?.showAlertNetworkError()
            }
        }

        return image
    }

    private func showAlertNetworkError() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему",
            buttonTexts: ["OK"]
        ) { [weak self] index in
            guard let self else {return}

            imagesListService.fetchPhotosNextPage()
        }

        alertPresenter?.show(alertModel: alert)
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

extension ImagesListViewController: ImageListCellDelegate {

    func imageListCellDidTapLike(_ cell: ImageListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = self.photos[indexPath.row]

        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlertNetworkError()
            }

        }
    }
}
