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
//            imageCellView.layer.cornerRadius = 16
//            imageCellView.clipsToBounds = true
//            imageCellView.bounds = bounds
//            print(imageCellView.bounds.width)
//            let gradientLayer = CAGradientLayer()
//            guard let imageHeight = imageCellView.image?.cgImage?.height else {return}
//            print(imageHeight)
//            gradientLayer.colors = [UIColor.transperant.cgColor, UIColor.transperantBlue.cgColor]
//////            gradientLayer.locations = [0.0, 1.0]
//////            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//////            gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
////
//            gradientLayer.frame = bounds
//            gradientLayer.bounds.size.height = 30
//            gradientLayer.frame.size.width = imageCellView.bounds.width
//            gradientLayer.position.y = CGFloat(imageCellView.frame.height - 15)
//
//            let width = imageCellView.frame.width
//            print(width)
//            imageCellView.layer.addSublayer(gradientLayer)

        }
    }
    
    @IBOutlet weak var imageCellViewDate: UILabel!
    
    @IBOutlet var gradienCellView: UIView! {
        didSet{
            gradienCellView.backgroundColor = UIColor.clear
            
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.colors = [UIColor.transperant.cgColor, UIColor.black.cgColor]
//            gradientLayer.locations = [0.0, 1.0]
//            gradientLayer.frame = CGRect(x: 0, y: 0, width: Int(self.gradienCellView.frame.size.width), height: 30)
////            gradientLayer.frame.size.height = 30
//            gradienCellView.layer.addSublayer(gradientLayer)
//            
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
