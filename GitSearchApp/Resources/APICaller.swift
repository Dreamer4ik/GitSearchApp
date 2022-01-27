//
//  APICaller.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants{
        static let gitHubLinkURL = URL(string: "https://api.github.com/")
        static let allPublicRepoLinkURL = URL(string: "https://api.github.com/repositories")
    }
    

    private init() {}
     
     public func getAllRepositories(completion: @escaping (Result<[Repository], Error>) -> Void) {
         guard let url = Constants.allPublicRepoLinkURL else {
             return
         }

         let task = URLSession.shared.dataTask(with: url) { data, _, error in
             if let error = error {
                 completion(.failure(error))
             }
             else if let data = data {
                 do {
                     let result = try JSONDecoder().decode(APIResponse.self, from: data)

//                     print("Repositories: \(result.repositories.count)")
                     completion(.success(result.repositories))
                 }
                 catch {
                     completion(.failure(error))
                 }
             }
         }
         task.resume()
     }
    
    
}



//Models
struct APIResponse: Codable {
    let repositories: [Repository]
    
}

struct Repository: Codable {
    let user: User
    let title: String
    let description: String
    let stargazers_url: String?
    let contributors_url: String?
    let languages_url: String?
}


struct User: Codable {
    let nameOwner: String
    let avatar_url: String?
}
