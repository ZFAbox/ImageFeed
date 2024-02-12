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
    
}
