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
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
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


