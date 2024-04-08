//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 21.01.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController:UIViewController {
    
    //MARK: - Privates
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView ()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "User Photo") ?? UIImage()
        profileImageView.image = image
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    private lazy var profileName: UILabel = {
        let profileName = UILabel()
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.text = "Екатерина Новикова"
        profileName.font = UIFont(name: "YSDisplay-Bold", size: 23)
        profileName.textColor = .ypWhite
        return profileName
    } ()
    private lazy var profileId: UILabel = {
        let profileId = UILabel()
        profileId.translatesAutoresizingMaskIntoConstraints = false
        profileId.text = "@ekaterina_nov"
        profileId.font = UIFont(name: "YSDisplay-Medium", size: 13)
        profileId.textColor = .userGray
        return profileId
    } ()
    private lazy var profileStatus: UILabel = {
        let profileStatus = UILabel()
        profileStatus.translatesAutoresizingMaskIntoConstraints = false
        profileStatus.text = "Hello, world!"
        profileStatus.font = UIFont(name: "YSDisplay-Medium", size: 13)
        profileStatus.textColor = .ypWhite
        return profileStatus
    } ()
    private let exitButton: UIButton = {
        let exitButton = UIButton(type: .system)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        exitButton.setBackgroundImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        exitButton.tintColor = .ypRed
        exitButton.addTarget(ProfileViewController.self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return exitButton
    } ()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private var storage = OAuth2TokenStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        applyConstrains()
        if let model = ProfileService.shared.profileModel {
            loadUserData(profileModel: model)}
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        )
        updateAvatar()
    }
    
    //MARK: - Layout Methods
    
    private func updateAvatar() {
        guard let profileImageURL = ProfileImageService.shared.profileImageUrl,
        let url = URL(string: profileImageURL)
        else { return }
        profileImageView.kf.setImage(with: url, placeholder: UIImage(named: "Placeholder"))
    }
    
    private func addSubViews(){
        view.addSubview(profileImageView)
        view.addSubview(profileName)
        view.addSubview(profileId)
        view.addSubview(profileStatus)
        view.addSubview(exitButton)
    }
    
    private func applyConstrains(){
        adjustProfileImage()
        adjustProfileName()
        adjustProfileID()
        adjustProfileStatus()
        adjustExitButton()
    }
    
    private func adjustProfileImage(){
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func adjustProfileName(){
        
        NSLayoutConstraint.activate([
            profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileName.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
    }
    
    private func adjustProfileID(){
        
        NSLayoutConstraint.activate([
            profileId.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileId.leadingAnchor.constraint(equalTo: profileName.leadingAnchor)
        ])
    }
    
    private func adjustProfileStatus(){
        
        NSLayoutConstraint.activate([
            profileStatus.topAnchor.constraint(equalTo: profileId.bottomAnchor, constant: 8),
            profileStatus.leadingAnchor.constraint(equalTo: profileId.leadingAnchor)
        ])
    }
    
    private func adjustExitButton(){
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    //MARK: - Button Actions
    @objc func exitButtonTapped(){
    }
    
    private func loadUserData(profileModel: ProfileModel) {
        profileName.text = profileModel.name
        profileId.text = profileModel.loginName
    }
}
