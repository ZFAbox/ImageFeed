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
//    private var profileStorage = ProfileDataStorage()
    
    private init(){}
    
    private enum GetUserDataError: Error {
        case invalidProfileRequest
    }
    private func makeProfileRequest (token: String) -> URLRequest? {
        guard let url = URL(string: mainUrlProfile) else {
            preconditionFailure("Ошибка формирования URL")
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print(request)
        request.httpMethod = "GET"
        print(request)
        return request
    }
    
    func fetchUserProfileData(token: String, handler: @escaping (Result<ProfileDataDecoder,Error>) -> Void) {
        
        guard let request = self.makeProfileRequest(token: token) else {
            handler(.failure(GetUserDataError.invalidProfileRequest))
            return
        }
        let task = URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
//                    print("Выводим данные профиля \(String(decoding: data, as: UTF8.self))")
                    let decodedData = try SnakeCaseJsonDecoder().decode(ProfileDataDecoder.self, from: data)
                    handler(.success(decodedData))
                } catch {
                    print("Ошибка декодирования данных пользователя")
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
        task.resume()
    }
    
//    func prepareProfileModel(token: String) {
//        self.fetchUserProfileData(token: token) { result in
//            switch result {
//            case .success(let decodedData):
//                let username = decodedData.username
//                let name = decodedData.firstName + " " + decodedData.lastName
//                let login = "@" + username
//                let bio = decodedData.bio
//                    let model = ProfileModel(
//                        username: username,
//                        name: name,
//                        loginName: login,
//                        bio: bio)
//                    self.profileStorage.profile = model
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
}
