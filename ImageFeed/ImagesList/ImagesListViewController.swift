//
//  ViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 29.12.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet private var imagesListTableView: UITableView! {
        didSet {
            imagesListTableView.backgroundColor = .ypBlack
            imagesListTableView.dataSource = self
            imagesListTableView.delegate = self
        }
    }
    
    //MARK: - Privates
    private let photoArray: [String] = Array(0..<20).map{ String($0) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListTableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    

    func dateFormat(date: Date) -> String {
        var curentDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dMMMMyyyy")
        for charackter in dateFormatter.string(from: date) {
            if charackter != "г" {
                if charackter != "." {
                    curentDate.append(charackter)
                }
            }
        }
        return curentDate
    }
    
    func configCell(for imagesListCell: ImagesListCell, indexPath: IndexPath) {
        imagesListCell.imageCellView?.image = UIImage(named: "\(indexPath.row)")
        imagesListCell.likeCellViewButton.imageView?.tintColor = indexPath.row % 2 == 0 ? UIColor.transperantWhite : UIColor.ypRed
//        let isLiked = indexPath.row % 2 == 0
//        let likeImage = isLiked ? UIImage(named: "isLiked") : UIImage(named: "notLiked")
//        imagesListCell.likeCellViewButton.setImage(likeImage, for: .normal)
        imagesListCell.imageCellViewDate?.text = dateFormat(date: Date())
            
        }
    }

    //MARK: - Extensions
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imagesListTableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            print("Ошибка приведения ячейки")
            return UITableViewCell()
        }
        configCell(for: imagesListCell, indexPath: indexPath)
        return imagesListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imageWidth = UIImage(named: "\(indexPath.row)")?.cgImage?.width else {return 10}
        let cellRowWidth = tableView.frame.width
        guard let imageHeight = UIImage(named: "\(indexPath.row)")?.cgImage?.height else { return 10 }
        let cellRowHeight = CGFloat(cellRowWidth) / CGFloat(imageWidth) * CGFloat(imageHeight) + 8
        return cellRowHeight
    }
}

