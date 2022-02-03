//
//  Response.swift
//  GitSearchApp
//
//  Created by Ivan on 03.02.2022.
//

import Foundation

struct Response: Codable {
   var idStr: String!
   var nameSrt: String!
   var ownerStr: String!

   var descriptionStr: String? = ""
   var link: String?
}
