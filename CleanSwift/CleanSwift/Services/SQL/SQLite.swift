//
//  SQLite.swift
//  CleanSwift_test
//
//  Created by Jang Dong Min on 2019/12/23.
//  Copyright © 2019 Paul Jang. All rights reserved.
//

import Foundation
import SQLite3

class SQLite {
    enum SQLError: Error {
        case connectionError
        case queryError
        case otherError
    }
    
    enum ColumnType {
        case int
        case double
        case text
    }
    
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    
    let path: String = {
        let fm = FileManager.default
        return fm.urls(for:.libraryDirectory, in:.userDomainMask).last!
                    .appendingPathComponent("data.db").path
    }()
    
    init() throws {
        guard sqlite3_open(path, &db) == SQLITE_OK
            else {
                throw SQLError.connectionError
        }
    }
    
    func install(query: String) throws {
        sqlite3_finalize(stmt)
        stmt = nil
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            return
        }
        throw SQLError.queryError
    }
    
    func bind(data:Any, withType type: ColumnType, at col: Int32 = 1) {
        switch type {
        case .int:
            if let value = data as? Int {
                sqlite3_bind_int(stmt, col, Int32(value))
            }
        case .double:
            if let value = data as? Double {
                sqlite3_bind_double(stmt, col, value)
            }
        case .text:
            if let value = data as? String {
                sqlite3_bind_text(stmt, col, value, -1, nil)
            }
        }
    }
    
    func execute(rowHandler:((OpaquePointer) -> Void)? = nil) throws {
        while true {
            switch sqlite3_step(stmt) {
            case SQLITE_DONE:
                return
            case SQLITE_ROW:
                rowHandler?(stmt!)
            default:
                throw SQLError.otherError
            }
        }
    }
    
    deinit {
        sqlite3_finalize(stmt)
        sqlite3_close(db)
    }
}
