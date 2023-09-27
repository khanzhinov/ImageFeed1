//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 06.09.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    private struct Keys {
        static let main = "Main"
        static let imagesListViewController = "ImagesListViewController"
        static let tabBarProfileImageName = "tab_profile_active"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        view.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
            let profileViewController = ProfileViewController()
            profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}

