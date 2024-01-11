//
//  ViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 30/11/23.
//

import UIKit

class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let photoNames: [String] = Array(0..<20).map{ "\($0)" }
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photoNames[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
  
    private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        guard let imageCell = UIImage(named: photoNames[indexPath.row]) else {
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
        return photoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIndentifier, for: indexPath)
        
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
        guard let image = UIImage(named: photoNames[indexPath.row]) else {
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


