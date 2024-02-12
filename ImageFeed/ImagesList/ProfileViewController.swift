//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Федор Завьялов on 21.01.2024.
//

import UIKit

final class ProfileViewController:UIViewController {
    
    //MARK: - Privates
    
    private var profileImageView = UIImageView()
    private var profileName = UILabel()
    private var profileId = UILabel()
    private var profileStatus = UILabel()
    private let exitButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustProfileImage()
        adjustProfileName()
        adjustProfileID()
        adjustProfileStatus()
        adjustExitButton()
    }
    
    //MARK: - Layout Methods
    func adjustProfileImage(){
        guard let image = UIImage(named: "User Photo") else { return }
        profileImageView.image = image
        profileImageView.layer.cornerRadius = 70 / 2
        profileImageView.clipsToBounds = true
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func adjustProfileName(){
        profileName.text = "Екатерина Новикова"
        profileName.font = UIFont(name: "YSDisplay-Bold", size: 23)
        profileName.textColor = .ypWhite
        view.addSubview(profileName)
        profileName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            profileName.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor)
        ])
    }
    
    func adjustProfileID(){
        profileId.text = "@ekaterina_nov"
        profileId.font = UIFont(name: "YSDisplay-Medium", size: 13)
        profileId.textColor = .userGray
        profileId.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileId)
        NSLayoutConstraint.activate([
            profileId.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8),
            profileId.leadingAnchor.constraint(equalTo: profileName.leadingAnchor)
        ])
    }
    
    func adjustProfileStatus(){
        profileStatus.text = "Hello, world!"
        profileStatus.font = UIFont(name: "YSDisplay-Medium", size: 13)
        profileStatus.textColor = .ypWhite
        profileStatus.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileStatus)
        NSLayoutConstraint.activate([
            profileStatus.topAnchor.constraint(equalTo: profileId.bottomAnchor, constant: 8),
            profileStatus.leadingAnchor.constraint(equalTo: profileId.leadingAnchor)
        ])
    }
    
    func adjustExitButton(){
        exitButton.setBackgroundImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        exitButton.tintColor = .ypRed
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        ])
    }
    
    //MARK: - Button Actions
    @objc func exitButtonTapped(){
    }
}
