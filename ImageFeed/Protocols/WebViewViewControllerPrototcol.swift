//
//  WebViewViewControllerPrototcol.swift
//  ImageFeed
//
//  Created by Fedor on 22.05.2024.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
}
