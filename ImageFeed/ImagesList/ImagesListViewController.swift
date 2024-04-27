//
//  ViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 29.12.2023.
//

import UIKit
import Kingfisher

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
    var photos: [Photo] = [] {
        didSet {
            if photos.count - 10 == 0 {
                imagesListTableView.reloadData()
            } else {
                updateTableViewAnimated()
            }
        }
    }
    private let photoArray: [String] = Array(0..<20).map{ String($0) }
    private let storage = OAuth2TokenStorage()
    private var showSingleImageSegueIdentifier = "ShowSingleImage"
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
//            let image = UIImage(named: photoArray[indexPath.row])
            let imageUrlStringForRow = photos[indexPath.row].largeImageURL
            let imageUrlForRow = URL(string: imageUrlStringForRow)
            guard let url = imageUrlForRow else { return }
            let data = try? Data(contentsOf: url)
            guard let data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                viewController.image = image
            }

        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageListService.shared.delegate = self
        imagesListTableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        if photos.isEmpty {
//            if let token = storage.token {
//                ImageListService.shared.fetchPhotoNextPage(token: token)
//            }
//        }
//        NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main) { _ in
//            self.imagesListTableView.reloadData()
//        }

//        photos = ImageListService.shared.photos
//        imagesListTableView.beginUpdates()
    }
    
    //MARK: - Class Methods
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
    
    func prepareGradientLayer(cell: ImagesListCell){
        cell.gradienCellView.layer.sublayers?.first?.removeFromSuperlayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0))
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30)
        cell.gradienCellView.layer.addSublayer(gradientLayer)
    }
    
    func configCell(for imagesListCell: ImagesListCell, indexPath: IndexPath) {
//        imagesListCell.imageCellView?.image = UIImage(named: "\(indexPath.row)")
//
        let imageUrlStringForRow = photos[indexPath.row].thumbImageURL
        let imageUrlForRow = URL(string: imageUrlStringForRow)
        imagesListCell.imageCellView.kf.setImage(with: imageUrlForRow, placeholder: UIImage(named: "Image placeholder"))
        
        imagesListCell.likeCellViewButton.imageView?.tintColor = indexPath.row % 2 != 0 ? UIColor.transperantWhite : UIColor.ypRed
        prepareGradientLayer(cell: imagesListCell)
        imagesListCell.imageCellViewDate?.text = dateFormat(date: Date())
        }
    
    func updateTableViewAnimated() {
        imagesListTableView.performBatchUpdates {
            let startIndex = photos.count - ImageListService.shared.perPage
            let endIndex = photos.count - 1
            for index in startIndex...endIndex {
                imagesListTableView.insertRows(at: [
                    IndexPath(row: index, section: 0)
                ], with: .automatic)
            }
        } completion: { _ in
        }
    }
}

    //MARK: - Extensions
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if photos.count - 1 == indexPath.row {
            if let token = storage.token {
                ImageListService.shared.fetchPhotoNextPage(token: token)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imagesListTableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            print("Ошибка приведения ячейки")
            return UITableViewCell()
        }
        
        print(indexPath.row)
        print(photos.count)


        configCell(for: imagesListCell, indexPath: indexPath)

        return imagesListCell
    }
    
}

//MARK: -Extensions
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imageWidth = UIImage(named: "\(indexPath.row)")?.cgImage?.width else {return 10}
        let cellRowWidth = tableView.frame.width
        guard let imageHeight = UIImage(named: "\(indexPath.row)")?.cgImage?.height else { return 10 }
        let cellRowHeight = CGFloat(cellRowWidth) / CGFloat(imageWidth) * CGFloat(imageHeight) + 8
        return cellRowHeight
    }
    

}

