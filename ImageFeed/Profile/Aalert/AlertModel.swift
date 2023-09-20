//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 06.09.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
    var secondButtonText: String? = nil
    var secondCompletion: () -> Void = {}
}
