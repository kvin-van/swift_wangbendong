//
//  Tools.swift
//  OneSwift
//
//  Created by van on 2017/9/25.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit
import CryptoSwift

 let  AESPWDKey  = "Jy_ApP_0!9i+90&#"

public typealias AlertBlock = (_ tag : NSInteger)->()

class Tools: NSObject {
   
}

//MARK: -  AES-128  加密解密
public func endcode_AES(strToEncode:String)->String
{
    // 从String 转成data
    let data = strToEncode.data(using: String.Encoding.utf8)
    // byte 数组
    var encrypted: [UInt8] = []
    do {
        encrypted = try AES(key:AESPWDKey ,iv: "2015030120123456",blockMode:.CBC,padding:.pkcs7).encrypt(data!.bytes)
//        encrypted = try AES(key: AESPWDKey, iv: "2015030120123456", blockMode: .CBC, padding: PKCS7()).encrypt(data!.bytes)//swift 3.1
    } catch {
        print(error)
    }
    let encoded =  Data(encrypted)
    
    return encoded.base64EncodedString()
}

public func decode_AES(strToDecode:String)->String
{
    //decode base64
    let data = NSData(base64Encoded: strToDecode, options: NSData.Base64DecodingOptions.init(rawValue: 0))
    // byte 数组
    var encrypted: [UInt8] = []
    let count = data?.length
    // 把data 转成byte数组
    for i in 0..<count! {
        var temp:UInt8 = 0
        data?.getBytes(&temp, range: NSRange(location: i,length:1 ))
        encrypted.append(temp)
    }
    // decode AES
    var decrypted: [UInt8] = []
    do {
        decrypted = try AES(key: AESPWDKey, iv: "2015030120123456", blockMode:.CBC, padding:.pkcs7).decrypt(encrypted)
    } catch {
        print(error)
    }
    
    // byte 转换成NSData
    let encoded = Data(decrypted)
    var str = ""
    //解密结果从data转成string
    str = String(bytes: encoded.bytes, encoding: .utf8)!
    
    return str
}

//MARK: -  字典 = JSON
//字典转化json
public func dictionaryChangeJson(dic :Dictionary<String, Any>)  -> (String){
    var jsonStr :String! = ""
    if !dic.isEmpty {
        let data = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        jsonStr = String(data : data! , encoding : String.Encoding.utf8)
    }
    
    return jsonStr
}

//json转化字典
public func jsonChangeDictionary(jsonStr : String)  -> (Dictionary<String, Any>){
    var  dict  : Dictionary<String, Any> = [:]
    let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false)
    let json = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers)
    let jsonStr = String(describing: json)
    if !jsonStr.isEmpty {
        dict = json as! Dictionary<String, Any>
    }
    return dict
}

//MARK: -  UIAlertController
public func showAlert(title :String? ,message:String?,superVC : UIViewController! , backBlock : @escaping AlertBlock)
{
    let alertControl = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction.init(title: "取消", style:.cancel) { (action) in
        backBlock(0)
    }
    let sureAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
        backBlock(1)
    }
alertControl.addAction(cancelAction)
    alertControl.addAction(sureAction)
    superVC.present(alertControl,animated: true,completion: nil)
}

public func showSimpleAlert(title :String? ,message:String?,superVC : UIViewController! )
{
    let alertControl = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
    let sureAction = UIAlertAction.init(title: "确定", style: .default) { (action) in
    }
    alertControl.addAction(sureAction)
    superVC.present(alertControl,animated: true,completion: nil)
}

