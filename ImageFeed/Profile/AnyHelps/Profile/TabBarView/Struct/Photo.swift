//
//  Photo.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 14.09.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
}
