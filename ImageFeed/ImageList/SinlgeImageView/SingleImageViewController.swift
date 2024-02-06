//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 30/12/23.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var imageURL: URL?

    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var scrollView: UIScrollView!
    private var alertPresenter: AlertProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25

        alertPresenter = AlertPresenter(viewController: self)

        setSingleImage()
    }

    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let imageToShare = imageView.image else {
            return
        }

        let activityViewController = UIActivityViewController(
            activityItems: [imageToShare],
            applicationActivities: nil
        )
        present(activityViewController, animated: true, completion: nil)
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }

    private func setSingleImage() {
        guard let imageURL else { return }

        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()

            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                print("error")
                self.showAlertNetworkError()
            }
        }
    }

    private func showAlertNetworkError() {
        let alert = AlertModel(
            title: "Что-то пошло не так(",
            message: "Попробовать ещё раз?",
            buttonTexts: ["Повторить", "Не надо"]
        ) { [weak self] index in
            guard let self else {return}

            if index == 0 {
                setSingleImage()
            } else {
                dismiss(animated: true)
            }
        }

        alertPresenter?.show(alertModel: alert)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
