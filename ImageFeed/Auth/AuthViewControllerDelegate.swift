//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 30.08.2023.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
