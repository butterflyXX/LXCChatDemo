//
//  DBManager.swift
//  LXCChatDemo
//
//  Created by 刘晓晨 on 2025/3/28.
//

import WCDBSwift
import Foundation

class DBManager {
    let database: Database
    let dbQueue: DispatchQueue = DispatchQueue.init(label: "kDBQueueIdentifier")
    init(dbPath: String) {
        NSLog(dbPath)
        database = Database(at: dbPath)
    }
    
    /// 创建表
    func createTable<T: TableDecodable>(table: String, itemType: T.Type, completion: ValueChanged<Error?>?) {
        dbQueue.async {
            do {
                try self.database.create(table: table, of: itemType)
                completion?(nil)
            } catch let error {
                completion?(error)
            }
        }
    }
    
    /// 插入
    func insert<T: TableEncodable>(table: String,
                                   items: [T],
                                   on propertyConvertibleList: [PropertyConvertible]? = nil,
                                   completion: ValueChanged<Error?>?) {
        dbQueue.async {
            do {
                try self.database.insert(items, on: propertyConvertibleList, intoTable: table)
                completion?(nil)
            } catch let error {
                completion?(error)
            }
        }
    }
    
    /// 更新
    func update<T: TableEncodable>(table: String,
                                   item: T,
                                   on: [PropertyConvertible],
                                   where condition: Condition? = nil,
                                   orderBy orderList: [OrderBy]? = nil,
                                   limit: Limit? = nil,
                                   offset: Offset? = nil,
                                   completion: ValueChanged<Error?>? = nil) {
        dbQueue.async {
            do {
                try self.database.update(table: table,
                                         on: on,
                                         with: item,
                                         where: condition,
                                         orderBy: orderList,
                                         limit: limit,
                                         offset: offset)
                completion?(nil)
            } catch let error {
                completion?(error)
            }
        }
    }
    
    /// 插入或者更新
    func insertOrReplace<T: TableEncodable>(table: String,
                                                    items: [T],
                                                    on: [PropertyConvertible]? = nil,
                                                    completion: ValueChanged<Error?>?) {
        dbQueue.async {
            do {
                try self.database.insertOrReplace(items, on: on, intoTable: table)
                completion?(nil)
            } catch let error {
                completion?(error)
            }
        }
    }
    
    /// 删除
    func delete(table: String,
                where condition: Condition? = nil,
                orderBy orderList: [OrderBy]? = nil,
                limit: Limit? = nil,
                offset: Offset? = nil,
                completion: ValueChanged<Error?>?) {
        dbQueue.async {
            do {
                try self.database.delete(fromTable: table, where: condition, orderBy: orderList, limit: limit, offset: offset)
                completion?(nil)
            } catch let error {
                completion?(error)
            }
        }
    }
    
    /// 查询
    func getObjects<T: TableDecodable>(table: String,
                                      on propertyConvertibleList: [PropertyConvertible],
                                      where condition: Condition? = nil,
                                      orderBy orderList: [OrderBy]? = nil,
                                      limit: Limit? = nil,
                                      offset: Offset? = nil,
                                      completion: @escaping ValueChanged<[T]?>) {
        dbQueue.async {
            do {
                let objects:[T] = try self.database.getObjects(on: propertyConvertibleList,
                                                              fromTable: table,
                                                              where: condition,
                                                              orderBy: orderList,
                                                              limit: limit,
                                                              offset: offset)
                completion(objects)
            } catch let _ {
                completion(nil)
            }
        }
    }
    
    /// 删除表
    func drop(table: String, completion: ValueChanged<Error?>?) {
        dbQueue.async {
            do {
                try self.database.drop(table: table)
                completion?(nil)
            } catch let error {
                completion?(error)
            }
        }
    }
    
    /// 删除数据库文件
    func removeFiles(completion: ValueChanged<Error?>?) {
        dbQueue.async {
            do {
                try self.database.close { [weak self] in
                    try self?.database.removeFiles()
                }
                completion?(nil)
            } catch let error {
                completion?(error)
            }
        }
    }
}
