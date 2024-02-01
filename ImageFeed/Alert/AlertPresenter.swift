//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Irina Deeva on 01/02/24.
//
import UIKit

final class AlertPresenter {
    weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

extension AlertPresenter: AlertProtocol {
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)

        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }

        alert.addAction(action)
        viewController?.present(alert, animated: true)
    }
}
