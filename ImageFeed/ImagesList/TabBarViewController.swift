//
//  TapBarViewController.swift
//  ImageFeed
//
//  Created by Fedor on 05.04.2024.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    enum ViewControllersList:String {
        case imagesListViewController = "ImagesListViewController"
        case profileViewController = "ProfileViewController"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: ViewControllersList.imagesListViewController.rawValue)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "Tab view person"),
            selectedImage: nil)
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
