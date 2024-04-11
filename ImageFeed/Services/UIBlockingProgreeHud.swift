//
//  UIBlockingProgreeHud.swift
//  ImageFeed
//
//  Created by Fedor on 27.03.2024.
//

import Foundation
import ProgressHUD
import UIKit

class UIBlockingProgressHud {
    private static var window: UIWindow? {
        UIApplication.shared.windows.first
    }
    
    static func show () {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animationType = .circleRippleSingle
        ProgressHUD.colorHUD = .black
        ProgressHUD.show("A few moments later...")
        }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
