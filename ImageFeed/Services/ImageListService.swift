//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Fedor on 17.04.2024.
//

import Foundation

class ImageListService {
    
    var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    var page: Int?
    var photosPerPage: Int?
    var task: URLSessionTask?
    
    private enum GetPhotoListError: Error {
        case invalidPhotoRequest
    }
    
    func makePhotoRequest(token: String, username: String, page: Int?) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: Constants.defaultBaseApiUrl) else {
            preconditionFailure("ошибка формирования строки запроса авторизации")
        }
            urlComponents.queryItems = [
                URLQueryItem(name: URLQueryItemsList.page.rawValue, value: Constants.accessKey),
                URLQueryItem(name: URLQueryItemsList.clientSecret.rawValue, value: Constants.secretKey),
                URLQueryItem(name: URLQueryItemsList.redirectURI.rawValue, value: Constants.redirectURI),
                URLQueryItem(name: URLQueryItemsList.code.rawValue, value: code),
                URLQueryItem(name: URLQueryItemsList.grantType.rawValue, value: Constants.grantType)
            ]
            guard let url = urlComponents.url else {
                preconditionFailure("Невозможно сформировать ссылку на запрос авторизации")}
            var request = URLRequest(url: url)
        
        guard let url = URL(string: mainUrlProfile) else {
            preconditionFailure("Ошибка формирования URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchPhotoNextPage (token: String, username: String, handler: @escaping (Result<PhotoResult,Error>) -> Void) {
        task?.cancel()
        guard let request = self.makePhotoRequest(token: token, username: username) else {
            handler(.failure(GetPhotoListError.invalidPhotoRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<PhotoResult, Error>) in
            switch result {
            case .success(let decodedPhotoList):
                handler(.success(decodedPhotoList))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
}
