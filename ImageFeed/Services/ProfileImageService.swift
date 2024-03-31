//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 01.04.2024.
//

import Foundation

final class ProfileImageService {
    
    static var shared = ProfileImageService()
    var profileImageUrl: String?
    private var mailImageProfileUrl = "https://api.unsplash.com/users/"
    private enum GetUserImageDataError: Error {
        case invalidProfileImageRequest
    }
    
    private init() {}
    
    private func makeProfileImageRequest (token: String, username: String) -> URLRequest? {
        let imageUrlString = mailImageProfileUrl + username
        guard let url = URL(string: imageUrlString) else {
            preconditionFailure("Ошибка формирования URL для получения изображения пользователя")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        request.httpMethod = "GET"
        print(request)
        return request
    }
    
    func fetchUserProfileImageData(token: String, username: String, handler: @escaping (Result<UserResultImageDecoder,Error>) -> Void) {
        
        guard let request = self.makeProfileImageRequest(token: token, username: username) else {
            handler(.failure(GetUserImageDataError.invalidProfileImageRequest))
            return
        }
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    print("Выводим инфрмацию пользователя \(String(decoding: data, as: UTF8.self))")
                    let decodedData = try SnakeCaseJsonDecoder().decode(UserResultImageDecoder.self, from: data)
                    handler(.success(decodedData))
                } catch {
                    print("Ошибка декодирования изображения пользователя")
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        task.resume()
    }
    
}
