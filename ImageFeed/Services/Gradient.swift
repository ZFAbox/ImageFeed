//
//  Gradient.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 14.05.2024.
//

import Foundation
import UIKit

class Gradient {
    
    private static var animationLayers = Set<CALayer>()
    
    static func addGradient(height: Int, width: Int, corenerRadius: Int?) -> CALayer {
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: CGFloat(width), height: CGFloat(height)))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        if let corenerRadius {
            gradient.cornerRadius = CGFloat(corenerRadius)
        }
        gradient.masksToBounds = true
        self.animationLayers.insert(gradient)
        
        let gradientAnimationLayer = CABasicAnimation(keyPath: "locations")
        gradientAnimationLayer.fromValue = [0, 0.1, 0.3]
        gradientAnimationLayer.toValue = [0, 0.8, 1]
        
        let opacity = CAKeyframeAnimation(keyPath: "opacity"
        )
        opacity.values = [0, 0.8, 0]
        
        let animationGroupe = CAAnimationGroup()
        animationGroupe.animations = [gradientAnimationLayer, opacity]
        animationGroupe.duration = 3
        animationGroupe.repeatCount = .infinity
        
        gradient.add(animationGroupe, forKey: "gradient")
        
        return gradient
    }
}

