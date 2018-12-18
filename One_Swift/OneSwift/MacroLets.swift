//
//  MacroLets.swift
//  OneSwift
//
//  Created by van on 2017/9/22.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit

/// 版本号
let Define_version = (UIDevice.current.systemVersion as NSString).floatValue
///  屏幕宽度
let Define_SCREEN_WIDTH = UIScreen.main.bounds.width
///  屏幕高度
let Define_SCREEN_HEIGHT = UIScreen.main.bounds.height
//
let Define_StatusHeight :CGFloat = 64.0
//
let Define_TabBarHeight :CGFloat = 49.0

let  Http_QueryMyWealth = "http://172.18.100.42:8080/xqAppServer/api/APPBizRest/queryMyWealth/v1/"

let Define_dbName : String = "PersonDB.sqlite"

func getDeviceUUID() -> (String) {
    let uuid : String! = (UIDevice.current.identifierForVendor?.uuidString) as String!
    
    return uuid;
}
