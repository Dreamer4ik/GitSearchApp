//
//  RepositoryInfo.swift
//  GitSearchApp
//
//  Created by Ivan on 03.02.2022.
//

import Foundation

struct SearchResponse: Codable {
   let items: [RepositoryInfo]
   
}

struct RepositoryInfo: Codable {
   let id: Int
   let name: String
   let owner: Owner
    
   var description: String?
   let html_url: String?
}

struct Owner: Codable {
   let login: String
}
