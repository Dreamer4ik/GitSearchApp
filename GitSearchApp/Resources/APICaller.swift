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
    
    var allReposData = [Int : [ViewModelDataPack]]()
    
    struct Constants{
        static let gitHubLinkURL = URL(string: "https://api.github.com/")
        static let allPublicRepoLinkURL = URL(string: "https://api.github.com/repositories")
        static let urlString = "https://api.github.com/repositories"
    }
    
    func getData() -> [Response]{
        
        var responses = [Response]()
        AF.request(Constants.urlString, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                for index in 0...json.count {
                    var currentResponse = Response()
                    
                    if let id = json[index]["id"].int {
                        currentResponse.idStr = "\(id)"
                    }
                    
                    if let name = json[index]["name"].string {
                        currentResponse.nameSrt = "\(name)"
                    }
                    
                    if let owner = json[index]["owner"]["login"].string {
                        currentResponse.ownerStr = "\(owner)"
                    }
                    
                    if let description = json[index]["description"].string {
                        currentResponse.descriptionStr = "\(description)"
                    }
                    
                    if let link = json[index]["url"].string  {
                        currentResponse.link = "\(link)"
                    }
                    
                    responses.append(currentResponse)
                    
                }
                
                print(responses.count)
                self.presentReposData(byResponcePack: responses, andPage: 1)
            case .failure(let error):
                print(error)
            }
        }
        return responses
    }
    
    
    func presentReposData(byResponcePack: [Response], andPage: Int) {
        
        var pageData = [ViewModelDataPack]()
        
        
        var viewModelsPack = ViewModelDataPack()
        for item in byResponcePack {
            viewModelsPack.idStr = item.idStr
            viewModelsPack.nameSrt = item.nameSrt
            viewModelsPack.ownerStr = item.ownerStr
            viewModelsPack.descriptionStr = item.descriptionStr
            viewModelsPack.link = item.link
            pageData.append(viewModelsPack)
            
        }
        let pagePack = [andPage: pageData]
        viewReposData(pagePack: pagePack)
    }
    
    func viewReposData(pagePack: [Int : [ViewModelDataPack]]) {
//        print(pagePack)
        allReposData[(pagePack.first?.key)!] = pagePack.first?.value
        
    }
    
    
  
}


struct Response: Codable {
    var idStr: String!
    var nameSrt: String!
    var ownerStr: String!
    
    var descriptionStr: String?
    var link: String?
    
}


struct ViewModelDataPack: Codable {
    var idStr: String!
    var nameSrt: String!
    var ownerStr: String!
    
    var descriptionStr: String?
    var link: String?
    
}
