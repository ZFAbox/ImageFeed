//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Fedor on 22.05.2024.
//

import Foundation

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
}


final class WebViewPresenter: WebViewPresenterProtocol {
    
    weak var view: WebViewViewControllerProtocol?
    func viewDidLoad() {
        
    }
    
}
