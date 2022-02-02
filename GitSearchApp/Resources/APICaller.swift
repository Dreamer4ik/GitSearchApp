//
//  APICaller.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import Foundation
import Alamofire
import SwiftyJSON


public class APICaller {
    static let shared = APICaller()
    
    /*
     let headers: HTTPHeaders = [
     "page": MY_API_KEY,
     "Accept": "application/json"
     ]

     */
//    let searchUrl = "https://github.com/search?q=BloggApp+in%3Aname&type=Repositories"
    
//    struct Constants{
//        static let gitHubLinkURL = URL(string: "https://api.github.com/")
//        static let allPublicRepoLinkURL = URL(string: "https://api.github.com/repositories")
//        static let urlString = "https://api.github.com/repositories"
//    }

    
    //(completion: @escaping (Result<[Article], Error>) -> Void)
    //func fetchRecipesData(completion : @escaping ([recipe]?, Error?)->()){
    
    public func getSearch(query: String, page: Int, endScroll: Bool, completion : @escaping ([Response], Error) -> ()){
        
       
    }
    
}





public struct SearchResponse: Codable {
    let total_count:  Int
    let incomplete_results: Bool
    let items: [Response]
    
}

public struct Response: Codable {
    var idStr: String!
    var nameSrt: String!
    var ownerStr: String!
    
    var descriptionStr: String? = ""
    var link: String?
}


public struct ViewModelDataPack: Codable {
    var idStr: String!
    var nameSrt: String!
    var ownerStr: String!
    
    var descriptionStr: String? = ""
    var link: String?
    
}
