//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 07.03.2024.
//

import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let unsplashPostRequestURLString = "https://unsplash.com/oauth/token"
    
    private init() {}
    
    private func makeAuthorizationRequest(code: String) -> URLRequest{
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
        
        let request = self.makeAuthorizationRequest(code: code)
        print(request)
        let urlSession = URLSession.shared.data(for: request) { result in
            switch result {
            case.success(let data):
                do {
                    let decodedData = try SnakeCaseJsonDecoder().decode(OAuthTokenResponseDecoder.self, from: data)
                    handler(.success(decodedData.accessToken))
                } catch {
                    print("Ошибка декодирования")
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        urlSession.resume()
    }

}
