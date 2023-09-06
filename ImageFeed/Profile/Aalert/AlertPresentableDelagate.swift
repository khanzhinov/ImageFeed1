//
//  AlertPresentableDelagate.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 06.09.2023.
//

import Foundation
import UIKit

protocol AlertPresentableDelagate: AnyObject {
    func present(alert: UIAlertController, animated flag: Bool)
}
