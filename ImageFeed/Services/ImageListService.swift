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
    var page: Int = 0
    var perPage: Int = 10
    var task: URLSessionTask?
    
    private enum GetPhotoListError: Error {
        case invalidPhotoRequest
    }
    
    func makePhotoRequest(token: String, username: String, page: Int, perPage: Int) -> URLRequest? {
        let urlString = Constants.defaultBaseApiUrl + "/photos"
        guard var urlComponents = URLComponents(string: urlString) else {
            preconditionFailure("ошибка формирования строки запроса авторизации")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: URLQueryItemsList.page.rawValue, value: String(page)),
            URLQueryItem(name: URLQueryItemsList.perPage.rawValue, value: String(perPage))
        ]
        guard let url = urlComponents.url else {
            preconditionFailure("Невозможно сформировать ссылку на запрос авторизации")}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchPhotoNextPage (token: String, username: String, handler: @escaping (Result<PhotoResult,Error>) -> Void) {
        if photos.count < page * perPage || task != nil {task?.cancel()}
        page += 1
        guard let request = self.makePhotoRequest(token: token, username: username, page: page, perPage: perPage) else {
            handler(.failure(GetPhotoListError.invalidPhotoRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<PhotoResult, Error>) in
            switch result {
            case .success(let decodedPhotoList):
                photos = decodedPhotoList
                handler(.success(decodedPhotoList))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func preparePhotoModel(photoResult: PhotoResult) -> [Photo] {
        var photoModel: [Photo] = []
        var photo: Photo
        for result in photoResult.photos {
            photo.id = result.id
            photo.createdAt = result.createdAt
            photo.size.width = CGFloat(result.width)
            photo.size.height = CGFloat(result.height)
            
        }
    }
    
}
