//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 25.01.2024.
//

import Foundation
import UIKit


class SingleImageViewController: UIViewController {
    
   //MARK: - Constants and Vars
   var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImageView.image = image
            imageScaleAdjustment(image: image)
        }
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var singleImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.layer.cornerRadius = 0.5 * shareButton.layer.bounds.height
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
//        scrollView.layer.bounds.height / image.size.height / ( scrollView.layer.bounds.width / image.size.width )
        imageScaleAdjustment(image: image)
        singleImageView.image = image
        let doubleTapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(adjustImageSize)
        )
        doubleTapRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    //MARK: - Class Methods
    @objc private func adjustImageSize() {
        
        if scrollView.zoomScale > 1 {
        scrollView.setZoomScale( scrollView.minimumZoomScale, animated: true)
        } else if scrollView.zoomScale == 1  {
            scrollView.setZoomScale( scrollView.maximumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale( 1, animated: true)
        }
    }
    
    func imageScaleAdjustment(image:UIImage){
        let minZoom = scrollView.minimumZoomScale
        let maxZoom = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        let scaleToFitWidth = scrollViewSize.width / imageSize.width
        let scaleToFitHeight = scrollViewSize.height / imageSize.height
        let scaleToFit = min(scaleToFitHeight, scaleToFitWidth)
        let minimalZoomScale = max(minZoom, scaleToFit)
        let scale = min(maxZoom, minimalZoomScale)
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let contentSize = scrollView.contentSize
        let x = (contentSize.width - scrollViewSize.width) / 2
        let y = (contentSize.height - scrollViewSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    func centerContent(){
        let visibleRectSize = scrollView.bounds.size
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func didTapShareButton() {
        let imageToShare = singleImageView.image
        let images = [ imageToShare! ]
        let activityViewController = UIActivityViewController(activityItems: images, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - IBActions
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        didTapShareButton()
    }
}

//MARK: - Extensions
extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        centerContent()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerContent()
    }
}
