//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 01.08.2023.
//

import UIKit
import Kingfisher
import WebKit

final class ProfileViewController: UIViewController {
    
    private struct Keys {
        static let main = "Main"
        static let logoutImageName = "logout_button"
        static let systemLogoutImageName = "ipad.and.arrow.forward"
        static let logOutActionName = "showAlert"
        static let systemAvatarImageName = "person.crop.circle.fill"
        static let avatarPlaceholderImageName = "avatar_placeholder"
        static let authViewControllerName = "AuthViewController"
    }
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var label: UILabel?
    private let translucentGradient = TranslucentGradient()
    private var alertPresenter: AlertPresenter?
    private var animationLayers = Set<CALayer>()
    
    private var avatarImageView: UIImageView = {

        let imageView = UIImageView(image: UIImage(systemName: Keys.systemAvatarImageName))
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let labelname = UILabel()
        labelname.textAlignment = .left
        labelname.textColor = .white
        labelname.font = .systemFont(ofSize: 23, weight: UIFont.Weight.bold)
        labelname.translatesAutoresizingMaskIntoConstraints = false
        
        return labelname
    }()
    
    private  var loginNameLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.textAlignment = .left
        loginLabel.textColor = .lightGray
        loginLabel.font = .systemFont(ofSize: 13)
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return loginLabel
    }()
    
    private var descriptionLabel: UILabel = {
        let descriptionText = UILabel()
        descriptionText.textColor = .white
        descriptionText.font = .systemFont(ofSize: 13)
        descriptionText.textAlignment = .left
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        
        return descriptionText
    }()
    
    
    
     var logOutButton: UIButton = {
        
        let image = UIImage(named: Keys.logoutImageName) ?? UIImage(systemName: Keys.systemLogoutImageName)!
        
        
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)

        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
        
        view.addSubview(avatarImageView)
        avatarImageSetup()
        
        view.addSubview(nameLabel)
        nameLabelSetup()
        
        view.addSubview(loginNameLabel)
        loginNameSetup()
        
        view.addSubview(descriptionLabel)
        descriptionLabelSetup()
        
        
        view.addSubview(logOutButton)
        logoutButtonSetup()
        
        
        
        updateProfileDetails(profile: profileService.profile)
        
        addGradients()
        alertPresenter = AlertPresenter(delagate: self)
        addButtonAction()
    }
    
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    func avatarImageSetup() {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = 35
        
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    func nameLabelSetup() {
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
    }
    
    func loginNameSetup() {
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
    }
    
    func descriptionLabelSetup() {
        descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
    }
    
    func logoutButtonSetup() {
        logOutButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    }
    
    @objc
    func didTapLogoutButton() {
        showAlertBeforeExit()
    }
    
}

private extension ProfileViewController {
    func updateAvatar() {
        guard
            let avatarURL = profileImageService.avatarURL,
            let url = URL(string: avatarURL)
        else { return }
        
        let avatarPlaceholderImage = UIImage(named: Keys.avatarPlaceholderImageName)
        
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: avatarPlaceholderImage,
            options: [.processor(processor)]
        ){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.removeGradients()
            case .failure:
                self.removeGradients()
                avatarImageView.image = avatarPlaceholderImage
            }
        }
    }
    
    func addGradients() {
        let avatarGradient = translucentGradient.getGradient(
            size: CGSize(
                width: 70,
                height: 70
            ),
            cornerRadius: avatarImageView.layer.cornerRadius)
        avatarImageView.layer.addSublayer(avatarGradient)
        animationLayers.insert(avatarGradient)
        
        let nameLabelGradient = translucentGradient.getGradient(size: CGSize(
            width: nameLabel.bounds.width,
            height: nameLabel.bounds.height
        ))
        nameLabel.layer.addSublayer(nameLabelGradient)
        animationLayers.insert(nameLabelGradient)
        
        let descriptionLabelGradient = translucentGradient.getGradient(size: CGSize(
            width: descriptionLabel.bounds.width,
            height: descriptionLabel.bounds.height
        ))
        descriptionLabel.layer.addSublayer(descriptionLabelGradient)
        animationLayers.insert(descriptionLabelGradient)
        
        let loginLabelGradient = translucentGradient.getGradient(size: CGSize(
            width: loginNameLabel.bounds.width,
            height: loginNameLabel.bounds.height
        ))
        loginNameLabel.layer.addSublayer(loginLabelGradient)
        animationLayers.insert(loginLabelGradient)
    }
}

private extension ProfileViewController {
        
    func removeGradients() {
        for gradient in animationLayers {
            gradient.removeFromSuperlayer()
        }
    }
    
    func addButtonAction() {
        if #available(iOS 14.0, *) {
            let logOutAction = UIAction(title: Keys.logOutActionName) { [weak self] (ACTION) in
                guard let self = self else { return }
                self.showAlertBeforeExit()
            }
            logOutButton.addAction(logOutAction, for: .touchUpInside)
        } else {
            logOutButton.addTarget(ProfileViewController.self,
                                   action: #selector(didTapLogoutButton),
                                   for: .touchUpInside)
        }
    }
    
    func showAlertBeforeExit(){
        DispatchQueue.main.async {
            let alert = AlertModel(
                title: "Пока, пока!",
                message: "Уверены что хотите выйти?",
                buttonText: "Да",
                completion: { [weak self] in
                    guard let self = self else { return }
                    self.logOut()
                },
                secondButtonText: "Нет",
                secondCompletion: { [weak self] in
                    guard let self = self else { return }
                    
                    self.dismiss(animated: true)
                })
            
            self.alertPresenter?.show(alert)
        }
    }
    
    
    func logOut() {
        OAuth2TokenStorage().token = nil
        WebViewViewController.cleanCookies()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
    }
}

extension ProfileViewController: AlertPresentableDelagate {
    func present(alert: UIAlertController, animated flag: Bool) {
        self.present(alert, animated: flag)
    }
}

