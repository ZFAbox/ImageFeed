//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 09.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    //MARK: - IBOutlets
    @IBOutlet var imageCellView: UIImageView!{
        didSet{
            imageCellView.layer.cornerRadius = 16
            imageCellView.clipsToBounds = true
        }
    }
    @IBOutlet weak var imageCellViewDate: UILabel!
    @IBOutlet var gradienCellView: UIView!
    @IBOutlet weak var likeCellViewButton: UIButton!
    
    //MARK: - Statics
    static let reuseIdentifier = "ImagesListCell"
    
    
    var photo: Photo?
    var delegate: ImagesListViewController?
    
    
    @IBAction func likeImage(_ sender: Any) {
        guard let photo = self.photo else {
            assertionFailure()
            return}
        guard let delegate else {return}
        print(photo.id)
        print(photo.isLiked)
        let newPhoto = delegate.didLikePhoto(id: photo.id, isLiked: photo.isLiked)
            self.photo = newPhoto
            likeCellViewButton.imageView?.tintColor = !photo.isLiked ? UIColor.ypRed : UIColor.transperantWhite
    }
    
//    func updateLike(photo: Photo) {
//        likeCellViewButton.imageView?.tintColor = photo.isLiked ? UIColor.ypRed : UIColor.transperantWhite
//    }
//    
}
