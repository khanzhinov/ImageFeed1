//
//  URLRequestExtension.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 30.08.2023.
//

import UIKit


extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = DefaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        return request
    }
}
