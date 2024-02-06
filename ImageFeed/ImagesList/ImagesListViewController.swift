//
//  ViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 29.12.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet private var imagesListTableView: UITableView! {
        didSet {
            imagesListTableView.backgroundColor = .ypBlack
            imagesListTableView.dataSource = self
            imagesListTableView.delegate = self
        }
    }
    
    //MARK: - Privates
    private let photoArray: [String] = Array(0..<20).map{ String($0) }
    private var showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photoArray[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesListTableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func dateFormat(date: Date) -> String {
        var curentDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("dMMMMyyyy")
        for charackter in dateFormatter.string(from: date) {
            if charackter != "г" {
                if charackter != "." {
                    curentDate.append(charackter)
                }
            }
        }
        return curentDate
    }
    
    func prepareGradientLayer(cell: ImagesListCell){
        cell.gradienCellView.layer.sublayers?.first?.removeFromSuperlayer()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
            UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0.2).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0))
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30)
        cell.gradienCellView.layer.addSublayer(gradientLayer)
    }
    
    func configCell(for imagesListCell: ImagesListCell, indexPath: IndexPath) {
        imagesListCell.imageCellView?.image = UIImage(named: "\(indexPath.row)")
        imagesListCell.likeCellViewButton.imageView?.tintColor = indexPath.row % 2 == 0 ? UIColor.transperantWhite : UIColor.ypRed
        prepareGradientLayer(cell: imagesListCell)
        imagesListCell.imageCellViewDate?.text = dateFormat(date: Date())
        }
    }

    //MARK: - Extensions
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = imagesListTableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            print("Ошибка приведения ячейки")
            return UITableViewCell()
        }
        configCell(for: imagesListCell, indexPath: indexPath)
        return imagesListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imageWidth = UIImage(named: "\(indexPath.row)")?.cgImage?.width else {return 10}
        let cellRowWidth = tableView.frame.width
        guard let imageHeight = UIImage(named: "\(indexPath.row)")?.cgImage?.height else { return 10 }
        let cellRowHeight = CGFloat(cellRowWidth) / CGFloat(imageWidth) * CGFloat(imageHeight) + 8
        return cellRowHeight
    }
}

