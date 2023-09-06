//
//  OAuth2TokenResponseBody.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 06.09.2023.
//

import Foundation

struct OAuth2TokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
