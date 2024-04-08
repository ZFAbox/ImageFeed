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
    private let authViewController = "AuthViewController"
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "LunchScreen") ?? UIImage()
        logoImageView.image = image
        return logoImageView
    } ()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            authViewControllerPresenter()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoImageView)
        view.backgroundColor = .ypBlack
        addConstraints()
        UIView.animate(withDuration: 0.3) {
            self.setNeedsStatusBarAppearanceUpdate()
        }

    }
    
    //MARK: - Class Methods
    
    private func addConstraints (){
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func authViewControllerPresenter () {
        guard let window = UIApplication.shared.windows.first else {
            fatalError("Неверная настройка")
        }
        if let authViewController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: authViewController) as? AuthViewController {
            window.rootViewController = authViewController
            authViewController.delegate = self
        }
    }
    
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
            }
        }
    }
    
    private func fetchProfileImageUrl (token: String, username: String) {
        UIBlockingProgressHud.show()
        profileImageService.fetchUserProfileImageData(token: token, username: username) { [self] result in
            UIBlockingProgressHud.dismiss()
            switch result {
            case .success(let decodedData):
                profileImageService.profileImageUrl = decodedData.profileImage.small
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



