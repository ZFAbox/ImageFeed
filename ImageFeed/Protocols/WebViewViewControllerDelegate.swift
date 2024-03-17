//
//  Protocols.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 27.02.2024.
//

import Foundation

protocol WebViewViewControllerDelegate:AnyObject {
    func webViewViewController( _ vc: WebViewViewController, didAuthenticateWithCode code: String )
    
    func webViewViewControllerDidCancel( _ vc:WebViewViewController )
}
