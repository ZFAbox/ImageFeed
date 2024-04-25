//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Fedor on 17.04.2024.
//

import Foundation

final class ImageListService {
    
    static var shared = ImageListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    var photos: [Photo] = []
    var page: Int = 0
    var perPage: Int = 10
    var task: URLSessionTask?
    
    private enum GetPhotoListError: Error {
        case invalidPhotoRequest
    }
    
    func makePhotoRequest(token: String, page: Int, perPage: Int) -> URLRequest? {
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
        print(request)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchPhotoNextPage (token: String) {
        if photos.count < page * perPage || task != nil {task?.cancel()}
        page += 1
        guard let request = self.makePhotoRequest(token: token, page: page, perPage: perPage) else {
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let decodedPhotoList):
                self.photos += self.preparePhotoModel(photoResult: decodedPhotoList)
                NotificationCenter.default.post(
                    name: ImageListService.didChangeNotification,
                    object: nil,
                    userInfo: ["Photos" : self.photos])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.task = task
        task.resume()
    }
    
    
    func preparePhotoModel(photoResult: [PhotoResult]) -> [Photo] {
        var photoModel: [Photo] = []
        for result in photoResult {
            let photo = Photo(
                id: result.id,
                size: CGSize(width: Double(result.width), height: Double(result.height)),
                createdAt: convertStringToDate(stringDate: result.createdAt),
                welcomeDescription: result.description,
                thumbImageURL: result.urls.thumb,
                largeImageURL: result.urls.full,
                isLiked: result.likedByUser)
            photoModel.append(photo)
        }
        return photoModel
    }
    
    func convertStringToDate(stringDate: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let stringDate else {
            print("Пустая дата")
            return nil}
        let date = dateFormatter.date(from: stringDate)
        return date
    }
    
}
