//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 01.04.2024.
//

import Foundation

final class ProfileImageService {
    
    //MARK: - Statics
    static var shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    var profileImageUrl: String?
    var task: URLSessionTask?
    
    //MARK: - Privates
    private var mailImageProfileUrl = "https://api.unsplash.com/users/"
    private enum GetUserImageDataError: Error {
        case invalidProfileImageRequest
    }
    
    private init() {}
    
    //MARK: - Class Methods
    private func makeProfileImageRequest (token: String, username: String) -> URLRequest? {
        let imageUrlString = mailImageProfileUrl + username
        guard let url = URL(string: imageUrlString) else {
            preconditionFailure("Ошибка формирования URL для получения изображения пользователя")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchUserProfileImageData(token: String, username: String, handler: @escaping (Result<UserResultImageDecoder,Error>) -> Void) {
        task?.cancel()
        guard let request = self.makeProfileImageRequest(token: token, username: username) else {
            handler(.failure(GetUserImageDataError.invalidProfileImageRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<UserResultImageDecoder, Error>) in
            switch result {
            case .success(let decodedData):
                handler(.success(decodedData))
                self.task = nil
            case .failure(let error):
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}
