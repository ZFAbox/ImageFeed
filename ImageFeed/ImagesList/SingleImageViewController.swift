//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 25.01.2024.
//

import Foundation
import UIKit


class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
                singleImageView.image = image
        }
    }
    
    @IBOutlet weak var singleImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        singleImageView.image = image
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
