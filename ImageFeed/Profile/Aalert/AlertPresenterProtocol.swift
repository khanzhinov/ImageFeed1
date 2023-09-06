//
//  AlertPresenterProtocol.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 06.09.2023.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    func show(_ alertArgs: AlertModel)
}
