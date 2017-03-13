//
//  DatabaseManager.swift
//  HFUTer3
//
//  Created by BrikerMan on 2017/3/11.
//  Copyright © 2017年 Eliyar Eziz. All rights reserved.
//

import Foundation
import FMDB

let DBManager = DatabaseManager.shared

enum HFBDTable: String {
    case schedule
}


protocol SQLiteCachable {
    var id: String { get }
    init(row: FMResultSet)
    func insertSQLStatement(tableName: String) -> (sql: String, values: [Any])
}


class DatabaseManager {
    let dbPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.eliyar.biz.hfuter")!.appendingPathComponent("db.sqlite").path
    
    static let shared = DatabaseManager()
    
    var databaseQueue: FMDatabaseQueue!
    
    /**
     Insert one item to db
     
     - parameter item: item model
     - parameter to:   target table type
     */
    func insert<T:SQLiteCachable>(item: T, to: HFBDTable) {
        let statement = item.insertSQLStatement(tableName: to.rawValue)
        databaseQueue.inTransaction { db, rollback in
            do {
                try db?.executeUpdate(statement.sql, values: statement.values)
                Logger.debug("\(item) inserted to \(to.rawValue) table")
            } catch {
                rollback?.pointee = true
                Logger.error(error.localizedDescription)
            }
        }
    }
    
    /**
     从列表删掉一个轮播频道ID
     - parameter piandaoId: 频道ID
     */
    func delete(id: [String], from: HFBDTable) {
        let db = FMDatabase(path: dbPath)!
        db.open()
        do {
            try db.executeUpdate(sql: "DELETE from \(from.rawValue) where id in (\(id.joined(separator: ",")));")
        } catch {
            Logger.error("DELETE from \(from.rawValue) where id in (\(id));  error \(error.localizedDescription)")
        }
        db.commit()
        db.close()
    }
    
    /**
     读取数据
     - returns: 读取model列表
     */
    func read<T:SQLiteCachable>(from: HFBDTable, type: T.Type, filter: String?) -> [T] {
        var models: [T] = []
        let db = FMDatabase(path: dbPath)!
        db.open()
        
        var sql = "SELECT * FROM \(from.rawValue)"
        if let filter = filter {
           sql += " WHERE " + filter
        }
        
        let rs = try! db.executeQuery(sql, values: [])
        while rs.next() {
            models.append(T(row: rs))
        }
        db.close()
        return models
    }
    
    func execute(sql: String) {
        let db = FMDatabase(path: dbPath)!
        db.open()
        do {
            try db.executeUpdate(sql: sql)
        } catch {
            Logger.error("Execute \(sql) error \(error.localizedDescription)")
        }
        db.commit()
        db.close()
    }
    
    func deleteAll(from: SQLiteCachable) {
        
    }
    
    init() {
        guard let database = FMDatabase(path: dbPath) else {
            Logger.error("unable to create database")
            return
        }
        
        guard database.open() else {
            Logger.error("Unable to open database")
            return
        }
        
        databaseQueue = FMDatabaseQueue(path: dbPath)
        
        do {
            try database.executeUpdate("CREATE TABLE \(HFBDTable.schedule.rawValue) (id TEXT PRIMARY KEY UNIQUE, name TEXT, colorName TEXT, isHidden Boolean, isUserAdded Boolean, hour INTEGER, day INTEGER, weeks TEXT);", values: nil)
            Logger.debug("created table success \(dbPath)")
        } catch {
            Logger.error("failed: \(error.localizedDescription)")
        }
    }
}