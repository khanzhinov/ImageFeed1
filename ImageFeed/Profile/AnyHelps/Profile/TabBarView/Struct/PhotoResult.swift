//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 14.09.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}

struct LikeResult: Codable {
    let photo: PhotoLikeResult
}

struct PhotoLikeResult: Codable {
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case likedByUser = "liked_by_user"
    }
}


