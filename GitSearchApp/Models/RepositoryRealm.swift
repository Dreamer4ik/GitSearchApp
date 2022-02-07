//
//  RepositoryRealm.swift
//  GitSearchApp
//
//  Created by Ivan on 07.02.2022.
//

import Foundation
import RealmSwift


class RepositoryRealm : Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var owner: String = ""
    
    @objc dynamic var descriptionRepo: String? = ""
    @objc dynamic var html_url: String? = ""
    
    @objc dynamic var stargazers_count: Int = 0
    
    //    override static func primaryKey() -> String? {
    //        return "id"
    //    }
    
    
    
    
}
