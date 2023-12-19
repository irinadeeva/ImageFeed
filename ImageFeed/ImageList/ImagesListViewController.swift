//
//  ViewController.swift
//  ImageFeed
//
//  Created by Irina Deeva on 30/11/23.
//

import UIKit

class ImagesListViewController: UIViewController {
    private let photoNames: [String] = Array(0..<20).map{ "\($0)" }
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configCell(for: UITableViewCell) {
        
    }
}

extension ImagesListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIndentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell() // change
        }
        
        configCell(for: imageListCell)
        return imageListCell
    }
    
    
}

extension ImagesListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
