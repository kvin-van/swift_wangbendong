//
//  Singleton.swift
//  OneSwift
//
//  Created by van on 2017/9/22.
//  Copyright © 2017年 van. All rights reserved.
//单例

import UIKit

class Singleton: NSObject {
    open var mobile : NSString!
    open var  userRegId: NSString!
    
//4、定义私有静态变量 通过公有方法访问
    private static let instance = Singleton();
    class func shareInstance() -> Singleton {
        return instance;
    }
    
    private override init() {
        print("Singleton 初始化了一次")
        mobile = "13010000000"
        userRegId = "382716"
    }
    
    //1、直接访问静态属性的方式
//    static let shareInstance = Singleton();
//    private override init() {
//        print("Singleton1 初始化了一次")
//    }
    
    //2、带立即执行的闭包初始化器的全局变量
//    static var shareInstance:Singleton = {
//        let instance = Singleton();
//        return instance;
//    }();
//    
//    private override init() {
//        print("Singleton2 初始化了一次")
//    }
}
