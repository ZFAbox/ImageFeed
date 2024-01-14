//
//  Colors.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 13.01.2024.
//

import UIKit

class Colors {
    let topColor = UIColor.transperant.cgColor
    let bottomColor = UIColor.black.cgColor
    
    var gradient: CAGradientLayer
    
    init () {
        self.gradient = CAGradientLayer()
        self.gradient.colors = [topColor, bottomColor]
        self.gradient.locations = [0.0, 1.1]
    }
}

extension UIColor{
    
    static var ypBlack: UIColor {UIColor(named: "YP Black") ?? UIColor.black}
    static var ypWhite: UIColor {UIColor(named: "YP White") ?? UIColor.black}
    static var ypRed: UIColor {UIColor(named: "YP Red") ?? UIColor.red}
    static var transperant: UIColor { UIColor(named: "Transperant") ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0)}
    static var transperantBlue: UIColor { UIColor(named: "Gradient") ?? UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)}
    static var transperantWhite: UIColor {UIColor(named: "Transperant White") ?? UIColor.white}
}
    
