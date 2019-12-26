//
//  Sql.swift
//  CleanSwift_test
//
//  Created by Jang Dong Min on 2019/12/23.
//  Copyright © 2019 Paul Jang. All rights reserved.
//

import Foundation
import SQLite3

class SqlService {
    static let shared = SqlService()
 
    init() {
        do {
            let db = try SQLite()
            try db.install(query:"CREATE TABLE IF NOT EXISTS jdmTB (id TEXT, avatar_url TEXT, score TEXT, login TEXT)")
            try db.execute()
        } catch {
            print(error)
        }
    }
    
    func saveData(id: String, avatar_url: String, score: String, login: String) {
        do {
            let db = try SQLite()
            try db.install(query:"INSERT INTO jdmTB (id, avatar_url, score, login) VALUES ('\(id)', '\(avatar_url)', '\(score)', '\(login)')")
            try db.execute()
            
            searchAllData()
            
        } catch {
            print(error)
        }
    }
    
    var idSet = Set<String>()
    var dataList: [SearchUserList.listPreview.ViewModel.listPreviewData] = []
    func searchAllData() {
        do {
            dataList.removeAll()
            idSet.removeAll()
            
            let db = try SQLite()
            try db.install(query:"SELECT * FROM jdmTB")
            try db.execute() { statement in
                let id = String(cString: sqlite3_column_text(statement, 0))
                let avatar_url = String(cString: sqlite3_column_text(statement, 1))
                let score = String(cString: sqlite3_column_text(statement, 2))
                let login = String(cString: sqlite3_column_text(statement, 3))

                let structData = SearchUserList.listPreview.ViewModel.listPreviewData.init(id: id, avatar_url: avatar_url, score: score, login: login)
                
                self.idSet.insert(id)
                self.dataList.append(structData)
            }
        } catch {
            print(error)
        }
    }

    func searchUser(login: String) {
        do {
            dataList.removeAll()
            
            let db = try SQLite()
            
            try db.install(query:"SELECT * FROM jdmTB WHERE login LIKE '%\(login)%'")
            try db.execute() { statement in
                let id = String(cString: sqlite3_column_text(statement, 0))
                let avatar_url = String(cString: sqlite3_column_text(statement, 1))
                let score = String(cString: sqlite3_column_text(statement, 2))
                let login = String(cString: sqlite3_column_text(statement, 3))

                let structData = SearchUserList.listPreview.ViewModel.listPreviewData.init(id: id, avatar_url: avatar_url, score: score, login: login)
 
                self.dataList.append(structData)
            }
        } catch {
            print(error)
        }
    }
    
    func deleteData(id: String) {
        do {
            let db = try SQLite()
            let sql = "DELETE FROM jdmTB WHERE id = \(id)"
            try db.install(query:sql)
            try db.execute()
            
            searchAllData()
            
        } catch {
            print(error)
        }
    }
    
}

 
