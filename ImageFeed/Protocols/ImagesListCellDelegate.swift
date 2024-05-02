//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Fedor on 02.05.2024.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike( _ cell: ImagesListCell)
}
