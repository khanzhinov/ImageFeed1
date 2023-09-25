//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 25.09.2023.
//


import Foundation

let DefaultBaseURL = URL(string: "https://api.unsplash.com")
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let authURLString: String
    let code = "code"
    let authPath = "/oauth/authorize/native"
    let clientId = "client_id"
    let redirectUriName = "redirect_uri"
    let responseType = "response_type"
    let scope = "scope"
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.AccessKey,
                                 secretKey: Constants.SecretKey,
                                 redirectURI: Constants.RedirectURI,
                                 accessScope: Constants.AccessScope,
                                 authURLString: unsplashAuthorizeURLString,
                                 defaultBaseURL: DefaultBaseURL)
    }
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: URL?
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}

private extension AuthConfiguration {
    enum Constants {
        static let AccessKey = "BxyX7iGkJCJzHExosk2vOpeY3a3LEDeaUQh7jE2z-zY"
        static let SecretKey = "Q6bPNxFjtBIWyhzrPAX0_cWJSNyCk-R_nV7fO4nmdO4"
        static let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let AccessScope = "public+read_user+write_likes"
    }
}
