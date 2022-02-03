//
//  ViewModelDataPack.swift
//  GitSearchApp
//
//  Created by Ivan on 03.02.2022.
//

import Foundation

struct ViewModelDataPack: Codable {
   var idStr: String!
   var nameSrt: String!
   var ownerStr: String!
   
   var descriptionStr: String? = ""
   var link: String?
   
}
