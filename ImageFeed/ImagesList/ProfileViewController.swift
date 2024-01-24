//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 21.01.2024.
//

import UIKit

final class ProfileViewController:UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileNameLable: UILabel!
    
    @IBOutlet weak var profileIdLable: UILabel!
    
    @IBOutlet weak var profileExitButton: UIButton! {
        didSet{
            profileExitButton.titleLabel?.text = ""
        }
    }
}
