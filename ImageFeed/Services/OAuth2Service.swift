//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 07.03.2024.
//

import Foundation
import ProgressHUD

final class OAuth2Service {
    
    //MARK: - Statics
    static let shared = OAuth2Service()
    
    //MARK: - Privates
    private let unsplashPostRequestURLString = "https://unsplash.com/oauth/token"
    private var task: URLSessionTask?
    var lastCode: String?
    private enum AuthServiceError: Error {
        case invalidRequest
    }
    
    private init() {}
    
    //MARK: - Class Methods
    private func makeAuthorizationRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: unsplashPostRequestURLString) else {
            preconditionFailure("ошибка формирования строки запроса авторизации")
        }
            urlComponents.queryItems = [
                URLQueryItem(name: URLQueryItemsList.clientId.rawValue, value: Constants.accessKey),
                URLQueryItem(name: URLQueryItemsList.clientSecret.rawValue, value: Constants.secretKey),
                URLQueryItem(name: URLQueryItemsList.redirectURI.rawValue, value: Constants.redirectURI),
                URLQueryItem(name: URLQueryItemsList.code.rawValue, value: code),
                URLQueryItem(name: URLQueryItemsList.grantType.rawValue, value: Constants.grantType)
            ]
            guard let url = urlComponents.url else {
                preconditionFailure("Невозможно сформировать ссылку на запрос авторизации")}
            var request = URLRequest(url: url)
            print(request)
            request.httpMethod = "POST"
            return request
    }
    
    func fetchOAuthToken(code: String, handler: @escaping (Result<String,Error>) -> Void) {
        UIBlockingProgressHud.show()
        guard lastCode != code else {
            handler(.failure(AuthServiceError.invalidRequest))
            return
        }
        task?.cancel()
        lastCode = code
        guard let request = self.makeAuthorizationRequest(code: code) else{
            handler(.failure(AuthServiceError.invalidRequest))
            return
            }
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseDecoder, Error>) in
            UIBlockingProgressHud.dismiss()
            guard let self = self else { return }
            switch result {
            case.success(let decodedData):
                handler(.success(decodedData.accessToken))
                    self.task = nil
                    self.lastCode = nil
            case .failure(let error):
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }

}
