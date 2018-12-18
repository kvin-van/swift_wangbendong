//
//  AES+Tools.swift
//  OneSwift
//
//  Created by van on 2017/9/22.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit

//class AES_Tools: NSObject {
//
//}

extension NSData{
    func AES128Crypt(operation:CCOperation,keyData:NSData)->NSData?{
        
        let keyBytes        = keyData.bytes
        let keyLength       = Int(kCCKeySizeAES256)
        
        let dataLength      = self.length
        let dataBytes       = self.bytes
        
        let cryptLength     = Int(dataLength+kCCBlockSizeAES128)
        var cryptPointer    = UnsafeMutablePointer<UInt8>.alloc(cryptLength)
        
        let algoritm:  CCAlgorithm = CCAlgorithm(kCCAlgorithmAES128)
        let option:   CCOptions    = CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding)
        
        var numBytesEncrypted = UnsafeMutablePointer<Int>.alloc(1)
        numBytesEncrypted.initialize(0)
        
        var cryptStatus = CCCrypt(operation, algoritm, option, keyBytes, keyLength, nil, dataBytes, dataLength, cryptPointer, cryptLength, numBytesEncrypted)
        
        if CCStatus(cryptStatus) == CCStatus(kCCSuccess) {
            let len = Int(numBytesEncrypted.memory)
            var data:NSData = NSData(bytesNoCopy: cryptPointer, length: len)
            
            numBytesEncrypted.dealloc(1)
            return data
            
        } else {
            numBytesEncrypted.dealloc(1)
            cryptPointer.dealloc(cryptLength)
            
            return nil
        }
    }
    
    static func test(){
        let keyString        = "12345678901234567890123456789012"
        let keyData: NSData! = (keyString as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        
        let message       = "Don´t try to read this text. Top Secret Stuff" //不要尝试阅读这个文字。 顶级秘密的东西
        let data: NSData! = (message as NSString).dataUsingEncoding(NSUTF8StringEncoding) as NSData!
        
        let result:NSData? = data.AES128Crypt(CCOperation(kCCEncrypt), keyData: keyData)
        println("encrypt = \(result)")
        
        let oldData = result?.AES128Crypt(CCOperation(kCCDecrypt), keyData: keyData)
        println("decrypt = \(oldData)")
    }
}
