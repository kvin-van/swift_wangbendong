//
//  UserBill.swift
//  OneSwift
//
//  Created by van on 2017/10/19.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit
import SQLite3
//import SQLite

private let sqlite_transient = unsafeBitCast(-1, to:sqlite3_destructor_type.self)

class UserBill: NSObject {
    
    
//MARK: - 查找全部
    func dbFindAll() -> Array<Dictionary<String, Any>> {
        var allArr : Array<Dictionary<String, Any>>? = Array()
        let db = SqliteManager.shareSqlite().openDB(sqliteName: Define_dbName)
        var stmt:OpaquePointer? = nil
        let cSql = String("select * from Person").cString(using: .utf8)
        let prepare_result = sqlite3_prepare_v2(db, cSql!, -1, &stmt, nil)
        
        if prepare_result == SQLITE_OK {
            //step
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                var person = Dictionary<String, Any>()
                //循环从数据库数据，添加到数组
                let id = UnsafePointer(sqlite3_column_text(stmt, 0))
                let name = UnsafePointer(sqlite3_column_text(stmt, 1))
                let age = sqlite3_column_int(stmt, 2)
                let image : UnsafeRawPointer = sqlite3_column_blob(stmt, 3)
                let length = sqlite3_column_bytes(stmt , 3)
                
                person["id"] = String.init(cString: id!)
                person["name"] = String.init(cString: name!)
                person["age"] = String(stringInterpolationSegment: age)
                person["image"] = Data(bytes:image, count: Int(length))
                
                allArr?.append(person)
            }

        }
        sqlite3_finalize(stmt)
        
        return allArr!
    }
    
    //MARK: -  新增
    func dbAdd(dictionary : Dictionary<String,Any>) -> Bool {
        let db = SqliteManager.shareSqlite().openDB(sqliteName:Define_dbName)
        var stmt:OpaquePointer? = nil
        //sql语句
        let sql = "INSERT INTO Person(id,name,age,image) VALUES(?,?,?,?);";
        //sql语句转换成cString类型
        let cSql = sql.cString(using: .utf8)
        
        //编译
        let prepare_result = sqlite3_prepare_v2(db, cSql!, -1, &stmt, nil)

        if prepare_result == SQLITE_OK {
            //绑定参数
            //最后一个参数为函数指针(swift 里必须要有否则无法添加)
            sqlite3_bind_text(stmt, 1, dictionary["id"] as? String, -1, sqlite_transient)
            sqlite3_bind_text(stmt, 2, dictionary["name"] as? String, -1, sqlite_transient)
            sqlite3_bind_int(stmt, 3, CInt(dictionary["age"] as! Int))
            sqlite3_bind_blob(stmt, 4,(dictionary["image"] as! Data).bytes, CInt((dictionary["image"] as! Data).count), sqlite_transient)
            
            //step执行
            let step_result = sqlite3_step(stmt)
            //判断执行结果
            if step_result != SQLITE_OK && step_result != SQLITE_DONE {
                sqlite3_finalize(stmt)
                print("插入错误 \(step_result)")
                return false
            }
        }
        else{
            print("插入错误")
        }
        
        sqlite3_finalize(stmt)
        return true
    }
    
    //MARK: -  删除
    func dbDeleteById(idStr : String) -> Bool {
        let db = SqliteManager.shareSqlite().openDB(sqliteName:Define_dbName)
        var stmt:OpaquePointer? = nil
         let sql = "DELETE FROM Person where id=?";
        let cSql = sql.cString(using: .utf8)
        let prepare_result = sqlite3_prepare_v2(db, cSql!, -1, &stmt, nil)
        
        if prepare_result == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, idStr, -1, sqlite_transient)  //给问号占位符赋值，sqlite3_prepare_v2中第一个？赋值参数sid
            //执行
            let step_result = sqlite3_step(stmt)
            if step_result == SQLITE_ERROR {
                sqlite3_finalize(stmt)
                print("删除失败\(step_result)")
                return false
            }
        }
        else{
            sqlite3_finalize(stmt)
            return false
        }
        sqlite3_finalize(stmt)
        return true
    }

    //MARK: - 更新
    func updateUser(dictionary : Dictionary<String,Any>) -> Bool {
        let db = SqliteManager.shareSqlite().openDB(sqliteName:Define_dbName)
        var stmt:OpaquePointer? = nil
        let sql = "UPDATE Person set name = '\(String(describing: dictionary["name"]))',age = '\(String(describing: dictionary["age"]))' where id = '\(String(describing: dictionary["id"]))' "
        let cSql = sql.cString(using: .utf8)
        
        //编译sql
        let prepare_result = sqlite3_prepare_v2(db, cSql!, -1, &stmt, nil)
        
        if prepare_result == SQLITE_OK {
            let step_result = sqlite3_step(stmt)
            if step_result == SQLITE_OK || step_result == SQLITE_DONE {
                sqlite3_finalize(stmt)
                return true
            }
            else{
                 print("更新失败\(step_result)")
            }
        }
        
        sqlite3_finalize(stmt)
        print("更新失败")
        return false
    }
}
