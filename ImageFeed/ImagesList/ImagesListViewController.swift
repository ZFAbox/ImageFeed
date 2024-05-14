//
//  ViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 29.12.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

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
            if oldValue.count == 0 {
                imagesListTableView.reloadData()
            } else if oldValue.count == photos.count {
                print ("Ставим лайк")
            }
            else{
                updateTableViewAnimated()
            }
        }
    }
    private let storage = OAuth2TokenStorage()
    private var showSingleImageSegueIdentifier = "ShowSingleImage"
    var destination: UITableViewCell?
    private var heightArray:[CGFloat] = []
    private var widthArray:[CGFloat] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let imageUrlStringForRow = photos[indexPath.row].largeImageURL
            guard let imageUrlForRow = URL(string: imageUrlStringForRow) else {
                preconditionFailure("Ошибка формирования URL для полноразмерного изображения")
            }
            loadFullSizeImage(on: viewController, with: imageUrlForRow)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListTableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main) { _ in
            self.photos = ImageListService.shared.photos
        }
    }
    
    //MARK: - Class Methods
    
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
    
    func addAnimation(cell: ImagesListCell, indexPath: IndexPath) {
        if cell.imageCellView.layer.sublayers?.first != nil {
            cell.imageCellView.layer.sublayers?.first?.removeFromSuperlayer()
        }
        cell.imageCellView.layer.addSublayer(
            Gradient.addGradient(
                height: Int(heightArray[indexPath.row]),
                width: Int(widthArray[indexPath.row]),
                corenerRadius: nil))
    }
    func configCell(for imagesListCell: ImagesListCell, indexPath: IndexPath) {
        let imageUrlStringForRow = photos[indexPath.row].thumbImageURL
        let imageUrlForRow = URL(string: imageUrlStringForRow)
        imagesListCell.imageCellView.kf.setImage(with: imageUrlForRow, placeholder: UIImage(named: "Image placeholder"))
        imagesListCell.likeCellViewButton.imageView?.tintColor = photos[indexPath.row].isLiked ? UIColor.ypRed : UIColor.transperantWhite
        addAnimation(cell: imagesListCell, indexPath: indexPath)
        prepareGradientLayer(cell: imagesListCell)
        if let date = photos[indexPath.row].createdAt {
            imagesListCell.imageCellViewDate?.text = DateFormatter.dateFormat(date: date)
        } else {
            imagesListCell.imageCellViewDate.text = ""
        }
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
                self.photos = ImageListService.shared.photos
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
        configCell(for: imagesListCell, indexPath: indexPath)
        imagesListCell.delegate = self
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
        let cellRowWidth = tableView.frame.width
        let imageWidth = photos[indexPath.row].size.width
        let imageHeight = photos[indexPath.row].size.height
        let scale = CGFloat(cellRowWidth) / CGFloat(imageWidth)
        let relativeIMageHegiht = scale * CGFloat(imageHeight)
        widthArray.append(cellRowWidth)
        heightArray.append(relativeIMageHegiht)
        let cellRowHeight = scale * CGFloat(imageHeight) + 8
        return cellRowHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = imagesListTableView.indexPath(for: cell) else {
            preconditionFailure("Ошибка формирования индекса ячейки")
        }
        let photo = photos[indexPath.row]
        let id = photo.id
        let isLiked = photo.isLiked
        ImageListService.shared.changeLike(photoId: id, isLike: isLiked) { result in
            switch result {
            case.success(let photo):
                if let index = self.photos.firstIndex(where: {$0.id == id}){
                    let newPhoto = Photo(
                        id: photo.photo.id,
                        size: CGSize(width: Double(photo.photo.width), height: Double(photo.photo.height)),
                        createdAt: ISO8601DateFormatter.convertStringToDate(stringDate: photo.photo.createdAt),
                        welcomeDescription: photo.photo.description,
                        thumbImageURL: photo.photo.urls.thumb,
                        largeImageURL: photo.photo.urls.full,
                        isLiked: photo.photo.likedByUser)
                    self.photos[index] = newPhoto
                    cell.setIsLiked(isLiked: photo.photo.likedByUser)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ImagesListViewController {
    
    private func showError(_ vc: SingleImageViewController, url: URL) {
        let alert = UIAlertController(title: "Что-то пошло не так. Попробовать еще раз?", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Не надо", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        let reloadImageAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.loadFullSizeImage(on: vc, with: url)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(reloadImageAction)
        vc.present(alert, animated: true, completion: nil)
    }
}

extension ImagesListViewController {
    
    private func loadFullSizeImage (on vc: SingleImageViewController, with url: URL) {
        let imageView = UIImageView()
        UIBlockingProgressHud.show()
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "Image placeholder")) { result in
            UIBlockingProgressHud.dismiss()
            switch result {
            case .success(let imageResult):
                vc.image = imageResult.image
            case .failure(let error):
                self.showError(vc, url: url)
                print(error.localizedDescription)
            }
        }
    }
}

