//
//  URLRequestExtension.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 30.08.2023.
//

import UIKit


extension URLRequest {
    /// Вспомогательная функция для создания HTTP запроса
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL? = DefaultBaseURL
    ) -> URLRequest? {
        guard let baseURL = baseURL,
              let url = URL(string: path, relativeTo: baseURL) else {
            assertionFailure("Failed to create URL with path: \(path)")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
