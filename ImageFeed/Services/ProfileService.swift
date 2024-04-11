//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Fedor on 27.03.2024.
//

import Foundation

final class ProfileService {
    
    static var shared = ProfileService()
    // MARK: - Privates
    var profileModel: ProfileModel?
    private var mainUrlProfile = "https://api.unsplash.com/me"
    private var task: URLSessionTask?
    private enum GetUserDataError: Error {
        case invalidProfileRequest
    }
    
    private init(){}
    
    private func makeProfileRequest (token: String) -> URLRequest? {
        guard let url = URL(string: mainUrlProfile) else {
            preconditionFailure("Ошибка формирования URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
    
    func fetchUserProfileData(token: String, handler: @escaping (Result<ProfileDataDecoder,Error>) -> Void) {
        task?.cancel()
        guard let request = self.makeProfileRequest(token: token) else {
            handler(.failure(GetUserDataError.invalidProfileRequest))
            return
        }
        let task = URLSession.shared.objectTask(for: request) { (result: Result<ProfileDataDecoder, Error>) in
            switch result {
            case .success(let decodedData):
                handler(.success(decodedData))
            case .failure(let error):
                handler(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    func prepareProfileModelFromData(data: ProfileDataDecoder) -> ProfileModel {
        let username = data.username
        let name = data.firstName + " " + data.lastName
        let login = "@" + username
        let bio = data.bio
        let profileModel = ProfileModel(
            username: username,
            name: name,
            loginName: login,
            bio: bio)
        return profileModel
    }
}
