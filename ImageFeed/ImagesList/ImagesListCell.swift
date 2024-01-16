//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 09.01.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
   
    //MARK: - IBOutlets
    
    @IBOutlet private var imageCellView: UIImageView!{
        didSet{
            imageCellView.layer.cornerRadius = 16
            imageCellView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var imageCellViewDate: UILabel!
    
    @IBOutlet private weak var gradienCellView: UIView! {
        didSet{
            gradienCellView.backgroundColor = UIColor.clear
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
                UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
            ]
            gradientLayer.locations = [0, 1]
            gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
            gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0))
            gradientLayer.frame.size.width = bounds.width
            gradientLayer.frame.size.height = 30
            gradienCellView.layer.addSublayer(gradientLayer)
        }
    }
    @IBOutlet private weak var likeCellViewButton: UIButton! {
        didSet{
            likeCellViewButton.titleLabel?.text = ""
        }
    }
    
    //MARK: - Statics
    
    static let reuseIdentifier = "ImagesListCell"
    
    //MARK: - Functions
    
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
    
    func configureCellContent(indexPath: IndexPath) {
            imageCellView?.image = UIImage(named: "\(indexPath.row)")
            likeCellViewButton.imageView?.tintColor = indexPath.row % 2 == 0 ? UIColor.transperantWhite : UIColor.ypRed
            imageCellViewDate?.text = dateFormat(date: Date())
    }
}
