//
//  SQLiteManager.swift
//  OneSwift
//
//  Created by van on 2017/10/18.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit
import SQLite

class SqliteManager: NSObject {
    
    static var sqliteManager : SqliteManager = SqliteManager()
    class func shareSqlite() -> SqliteManager {
        return sqliteManager
    }
    
    private override init() {
        print("sqliteManager 初始化了一次")
    }
    
    //数据库对象
var db:OpaquePointer? = nil
    
func openDB(sqliteName:String!) -> OpaquePointer{
        if (db != nil){
            return db!
        }
        //0.拿到数据库的路径
        var path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as NSString
        path = path.appendingPathComponent(sqliteName) as NSString
        print(path)
        
        var dbName : Array<String> =  sqliteName.components(separatedBy: CharacterSet.init(charactersIn: "."))
        let dbPath :String  =  Bundle.main.path(forResource:dbName[0] , ofType: dbName[1])!
        
        let fm :FileManager = FileManager.default
        if fm.fileExists(atPath: path as String) == false {
            do { // bundle里面的东西不能移动只能copy
                try fm.copyItem(atPath: dbPath, toPath: path as String)
            }
            catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        //1.需要代开的数据库的路径 c语言的字符串
        //2.打开之后的数据库对象（指针）,以后所有的数据库操作，都必须拿到这个指针才能进行相关操作
        let cpath = path.cString(using: String.Encoding.utf8.rawValue)
        if sqlite3_open(cpath, &db) != SQLITE_OK{
            print("数据库打开失败")
        }
        return db!
//        if creatTable(){
//            print("创建表成功")
//        }else{
//            print("创建表失败")
//        }
    }
    
    //创建表
    private func creatTable(tableName:String!) -> Bool
    {
        // 1.编写SQL语句
        // 建议: 在开发中编写SQL语句, 如果语句过长, 不要写在一行
        // 开发技巧: 在做数据库开发时, 如果遇到错误, 可以先将SQL打印出来, 拷贝到PC工具中验证之后再进行调试
        let sql = "CREATE TABLE IF NOT EXISTS \(tableName)( \n" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
            "name TEXT, \n" +
            "age INTEGER \n" +
        "); \n"
            print(sql)
        
        return execSQL(sql: sql)
    }
    
    // 2.执行SQL语句
    func execSQL(sql: String) -> Bool
    {
        // 0.将Swift字符串转换为C语言字符串
        let cSQL = sql.cString(using: String.Encoding.utf8)!
//        var errmsg : UnsafePointer<Int8>? = nil
        var errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>!
        errmsg = nil
        // 在SQLite3中, 除了查询意外(创建/删除/新增/更新)都使用同一个函数
        /*
         1. 已经打开的数据库对象
         2. 需要执行的SQL语句, C语言字符串
         3. 执行SQL语句之后的回调, 一般传nil
         4. 是第三个参数的第一个参数, 一般传nil
         5. 错误信息, 一般传nil
         */
        if sqlite3_exec(db, cSQL, nil, nil, errmsg) != SQLITE_OK
        {
           print("ERROR: sqlite3_exec \(errmsg)")
            return false
        }
        return true
    }
    
    // 3.关闭数据库
    func closeDB() -> Bool {
        if db != nil {
            if sqlite3_close(db) != SQLITE_OK {
                return false
            }
            return true
        }
        return false
    }
    
}
