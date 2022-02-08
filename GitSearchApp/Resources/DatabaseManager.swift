//
//  DatabaseManager.swift
//  GitSearchApp
//
//  Created by Ivan on 25.01.2022.
//

import Foundation
import UIKit
import RealmSwift

public class DatabaseManager {

    public var   database:Realm
    static let   shared = DatabaseManager()
    
    private init() {
        database = try! Realm()
    }
    
    
    func getDataFromDB() ->   Results<RepositoryRealm> {
        let results: Results<RepositoryRealm> =   database.objects(RepositoryRealm.self)
        
        return results
    }
    func addData(object: RepositoryRealm)   {
        try! database.write {
            //            database.add(object, update: .all)
            //            database.add(object, update: true)
            database.add(object)
            print("Added new object")
        }
    }
    func deleteAllFromDatabase()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    func deleteFromDb(object: RepositoryRealm)   {
        try!   database.write {
            database.delete(object)
        }
    }
    
    func getIdFromDB() -> [Int] {
        let results =   database.objects(RepositoryRealm.self)
        var saveId:[Int] = []
        for value in results {
            saveId.append(value.id)
        }
        return saveId
    }
    
}
