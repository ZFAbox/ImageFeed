//
//  WebViewViewControllerPrototcol.swift
//  ImageFeed
//
//  Created by Fedor on 22.05.2024.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func setProgressValue(_ newValue: Float)
    func setProgressIsHidden(_ isHidden: Bool)
    func load(request: URLRequest)
}
