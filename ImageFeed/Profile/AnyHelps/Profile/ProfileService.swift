//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Валерия Медведева on 05.09.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    private struct Keys {
        static let authorization = "Authorization"
        static let bearer = "Bearer"
        static let nilBio = "User has no description"
        static let nilLastName = ""
        static let httpMethodGet = "GET"
    }
    
    private init() { }
    
    func fetchProfile(
        _ token: String,
        completion: @escaping (Result<Profile, Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if profile != nil { return }
        task?.cancel()
        
        var requestProfile = selfProfileRequest
        requestProfile?.addValue("\(Keys.bearer) \(token)", forHTTPHeaderField: Keys.authorization)
        
        guard let requestProfile = requestProfile else {
            return
        }
        
        let task = urlSession.objectTask(for: requestProfile) { [weak self] (result: Result<ProfileResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let body):
                    let profile = Profile(
                        username: body.username,
                        name: "\(body.firstName) \(body.lastName ?? Keys.nilLastName )",
                        bio: body.bio ?? Keys.nilBio
                    )
                    
                    self.profile = profile
                    
                    completion(.success(profile))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.profile = nil
                }
            }
        }
        
        self.task = task
        task.resume()
    }
    
}

private extension ProfileService {
   
    var selfProfileRequest: URLRequest? {
        URLRequest.makeHTTPRequest(path: "/me", httpMethod: Keys.httpMethodGet)
    }
}


struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

public struct Profile {
    let username: String
    let name: String
    var loginName: String {
        get {
            "@\(username)"
        }
    }
    let bio: String
}
