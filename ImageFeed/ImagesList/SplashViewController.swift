//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Fedor on 18.03.2024.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {

    //MARK: - Privates
    private let loginSplashViewIdentifier = "LoginSplashViewIdentifier"
    private let tapBarViewControllerId = "TapBarViewController"
    private let storage = OAuth2TokenStorage()
    private let profileStorage = ProfileDataStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    let semaphore = DispatchSemaphore(value: 0)

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage.token {
            print(token)
//            switchToTapBarController()
            fetchProfile(token: token)
//            print("Name: \(String(describing: self.profileService.profileModel?.username))")
//            if let username = profileService.profileModel?.username {
//            fetchProfileImageUrl(token: token, username: "zfabox")
//            }
        } else {
            performSegue(withIdentifier: loginSplashViewIdentifier, sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginSplashViewIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(loginSplashViewIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: - Class Methods
    private func switchToTapBarController (){
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Неверная настройка")
        }
        let tapBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tapBarViewControllerId)
        window.rootViewController = tapBarController
    }
    
    func didAuthenticate (_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        guard let token = storage.token else {
            return
        }
        fetchProfile(token: token)
        switchToTapBarController()
    }
    
    private func fetchProfile(token: String) {
        UIBlockingProgressHud.show()
        profileService.fetchUserProfileData(token: token) { [self] result in
            UIBlockingProgressHud.dismiss()
                switch result {
                case .success(let decodedData):
                    let username = decodedData.username
                    let name = decodedData.firstName + " " + decodedData.lastName
                    let login = "@" + username
                    let bio = decodedData.bio
                        let model = ProfileModel(
                            username: username,
                            name: name,
                            loginName: login,
                            bio: bio)
                    profileService.profileModel = model
                    print(username)
                    fetchProfileImageUrl(token: token, username: username)
                    switchToTapBarController()
                case .failure(let error):
                    print(error.localizedDescription)
//                    assertionFailure("Не удалось получить данные профиля")
                }
            }
        }
    
    private func fetchProfileImageUrl (token: String, username: String) {
//        UIBlockingProgressHud.show()
        profileImageService.fetchUserProfileImageData(token: token, username: username) { [self] result in
//            UIBlockingProgressHud.dismiss()
                switch result {
                case .success(let decodedData):
                    profileImageService.profileImageUrl = decodedData.profileImage.small
                    print(profileImageService.profileImageUrl!)
//                    switchToTapBarController()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        guard let profileImageUrl = profileImageService.profileImageUrl else { return }
        NotificationCenter.default.post(
            name: ProfileImageService.didChangeNotification,
            object: self,
            userInfo: ["URL": profileImageUrl])

        }
    }



