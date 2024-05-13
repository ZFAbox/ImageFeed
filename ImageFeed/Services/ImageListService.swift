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
    private var task: URLSessionTask?
    let storage = OAuth2TokenStorage()
    
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
        if (photos.count < page * perPage) || (task != nil) {
            task?.cancel()
            return
        }
        page += 1
        guard let request = self.makePhotoRequest(token: token, page: page, perPage: perPage) else {
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let decodedPhotoList):
                self.photos += self.preparePhotoModel(photoResult: decodedPhotoList)
                print("Запрос фотографий")
                self.task = nil
                NotificationCenter.default.post(
                    name: ImageListService.didChangeNotification,
                    object: nil,
                    userInfo: ["Photos" : self.photos])
            case .failure(let error):
                print(error.localizedDescription)
                self.task = nil
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
                createdAt: ISO8601DateFormatter.convertStringToDate(stringDate: result.createdAt),
                welcomeDescription: result.description,
                thumbImageURL: result.urls.thumb,
                largeImageURL: result.urls.full,
                isLiked: result.likedByUser)
            photoModel.append(photo)
        }
        return photoModel
    }
    
    func makeLikeRequest(token: String, photoId: String, isLiked: Bool) -> URLRequest? {
        let urlString = Constants.defaultBaseApiUrl + "photos/" + photoId + "/like"
        print(urlString	)
        let url = URL(string: urlString)
        guard let url else { preconditionFailure("Невозможно сформировать URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLiked ? "DELETE" : "POST"

        return request
    }
    
    func changeLike (photoId: String, isLike: Bool, _ compliction: @escaping (Result<SinglePhotoUpdate, Error>) -> Void) {
        guard let token = storage.token else {
            preconditionFailure() }
        guard let request = makeLikeRequest(token: token, photoId: photoId, isLiked: isLike) else { return }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<SinglePhotoUpdate, Error>) in
            switch result {
            case .success(let photo):
                compliction(.success(photo))
            case .failure(let error):
                compliction(.failure(error))
            }
        }
        task.resume()
    }
    
}
