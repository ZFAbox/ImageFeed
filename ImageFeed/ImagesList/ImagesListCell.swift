//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 09.01.2024.
//

import UIKit


final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var imageCellView: UIImageView!{
        didSet{
            imageCellView.layer.cornerRadius = 16
            imageCellView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var imageCellViewDate: UILabel!
    
    @IBOutlet var gradienCellView: UIView! {
        didSet{
            gradienCellView.backgroundColor = UIColor.clear
        }
    }
    
  
    
    
    @IBOutlet weak var likeCellViewButton: UIButton! {
        didSet{
            likeCellViewButton.titleLabel?.text = ""
        }
    }
    
    let color = Colors()
    
    static let reuseIdentifier = "ImagesListCell"
    
}
