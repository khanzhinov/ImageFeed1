//
//  RootNavigationController.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 04.09.2023.
//

import Foundation
import UIKit

final class RootNavigationController: UINavigationController {
    
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
