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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.layer.cornerRadius = 0.5 * shareButton.layer.bounds.height
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = scrollView.layer.bounds.height / image.size.height / ( scrollView.layer.bounds.width / image.size.width )
        singleImageView.image = image
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(adjustImageSize)
        )
        doubleTapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    @objc private func adjustImageSize (image: UIImage) {
        if scrollView.zoomScale > 1 {
        scrollView.setZoomScale( scrollView.minimumZoomScale, animated: true)
        } else if scrollView.zoomScale == 1  {
            scrollView.setZoomScale( scrollView.maximumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale( 1, animated: true)
        }
    }
    
    func didTapShareButton() {
        let imageToShare = singleImageView.image
        let images = [ imageToShare! ]
        
        let activityViewController = UIActivityViewController(activityItems: images, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        didTapShareButton()
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageView
    }
    
}
