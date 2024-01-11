//
//  ViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 29.12.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {

    @IBOutlet private var imagesListTableView: UITableView! {
        didSet {
            imagesListTableView.backgroundColor = .ypblack
            imagesListTableView.dataSource = self
            imagesListTableView.delegate = self
            imagesListTableView.register(ImagesListCell.self, forCellReuseIdentifier: "ImagesListCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    func configCell(for: ImagesListCell) {
        
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imagesListTableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imgesListCell = cell as? ImagesListCell else {
            print("Нет ячейки соответствющей индентификатору ImageListCell")
            return UITableViewCell()
        }
        
        configCell(for: imgesListCell)
        return imgesListCell
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

