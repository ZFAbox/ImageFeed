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
//    {
//        didSet{
//            gradienCellView.backgroundColor = UIColor.clear
//            
////                let gradientLayer = CAGradientLayer()
////                gradientLayer.colors = [
////                    UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
////                    UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
////                ]
////                gradientLayer.locations = [0, 1]
////                gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.5)
////                gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
////                gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0))
////                gradientLayer.frame.size.width = bounds.width
////                gradientLayer.frame.size.height = 30
////                gradientLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 30)
////                gradienCellView.layer.addSublayer(gradientLayer)
//        }
//    }
    @IBOutlet weak var likeCellViewButton: UIButton!
    
    //MARK: - Statics
    static let reuseIdentifier = "ImagesListCell"
    
}



//    @IBDesignable
//    public class Gradient: UIView {
//        @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
//        @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
//        @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
//        @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
//        @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
//        @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
//
//        override public class var layerClass: AnyClass { CAGradientLayer.self }
//
//        var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
//
//        func updatePoints() {
//            if horizontalMode {
//                gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
//                gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
//            } else {
//                gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
//                gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
//            }
//        }
//        func updateLocations() {
//            gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
//        }
//        func updateColors() {
//            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
//        }
//        override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//            super.traitCollectionDidChange(previousTraitCollection)
//            updatePoints()
//            updateLocations()
//            updateColors()
//        }
//
//    }
