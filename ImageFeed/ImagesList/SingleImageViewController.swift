//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 25.01.2024.
//

import Foundation
import UIKit


final class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var SingleImageView: UIImageView!
    
    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
