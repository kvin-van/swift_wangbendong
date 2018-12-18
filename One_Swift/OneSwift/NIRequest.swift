//
//  NIRequest.swift
//  TrueFace
//
//  Created by zhouen on 2017/4/6.
//  Copyright © 2017年 zhouen. All rights reserved.
//

import UIKit
import Alamofire

let  AESBodyEncrypt :String = "aesRequest" //AES加密请求字段
let AESBodyDecrypt : String = "aesResponse"//AES解密请求字段

//typealias是用来为已经存在的类型重新定义名字的,通过命名
public typealias Success = (_ response : [String : Any])->()
public typealias Failure = (_ error : Error)->()

var headDic : HTTPHeaders = HTTPHeaders()

class NIRequest: NSObject {

    ///单例写法（此处无需单例 直接用类方法）
    static let shared = NIRequest()
    private override init() {
        // 初始化一些内容
//        headDic["pid"]  = getDeviceUUID()
        headDic["pid"] = "A2BB8D1F-4107-4BDD-91EA-EDCF00552F8D"
        headDic["Accept-Language"] = "en;q=1"
        headDic["User-Agent"] = "JYFinance/1.7.2 (iPhone; iOS 11.0; Scale/3.00)"
    }
}

// MARK: -------- GET POST
extension NIRequest {
    /// GET请求
    class func getRequest(_ urlString: String,params: Parameters? = nil, success: @escaping Success,failure: @escaping Failure)
    {
        print("发送请求： \(urlString) \n \(String(describing: params))")
        let jsonStr = dictionaryChangeJson(dic: params!)
        let aes = endcode_AES(strToEncode: jsonStr)
        let dic = [AESBodyEncrypt : aes]
        requestOfService(urlString, params: dic, methods: .get, success, failure)
    }
    
    // POST请求 @escaping 逃逸
    class func postRequest(_ urlString: String,params: Parameters? = nil,
        success: @escaping Success,failure: @escaping Failure)
    {
        print("发送请求： \(urlString) \n \(String(describing: params))")
        
        let jsonStr = dictionaryChangeJson(dic: params!)
        let aes = endcode_AES(strToEncode: jsonStr)
        let dic = [AESBodyEncrypt : aes]
        requestOfService(urlString, params: dic, methods: HTTPMethod.post, success, failure)
    }
    
    private class func requestOfService(
        _ urlString: String,
        params: Parameters? = nil,
        methods: HTTPMethod,
        _ success: @escaping Success,
        _ failure: @escaping Failure)
    {
        
        Alamofire.request(urlString, method:methods, parameters: params, encoding: JSONEncoding.default, headers: headDic)
            .validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success:
                var dic : Dictionary<String, Any> = [:]
                do{
                    dic = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! Dictionary
                }catch{
                    print(error)
                }
                let aesStr = dic[AESBodyDecrypt]
               let dataStr = decode_AES(strToDecode: aesStr as! String )
                let responseDic = jsonChangeDictionary(jsonStr: dataStr) 
                print("返回数据： \(String(describing: response.data)) \(responseDic)")
                success(responseDic)
               
            case .failure(let error):
                failure(error)
            }
        }
    }
}

// MARK: -------- 上传(可多文件上传)
extension NIRequest {
    /// 单文件上传
    ///
    /// - Parameters:
    ///   - urlString:
    ///   - data: 二进制文件
    ///   - name: 和后台约定字段名称
    ///   - fileName: xx.png xx.jpg xx.zip...
    class func upLoadImage(
        _ urlString: String,
        data: Data,
        name: String = "image",
        fileName: String = "image.png",
        params: Parameters? = nil,
        success: @escaping Success,
        failure: @escaping Failure)
    {
        upLoadFiles(urlString, data: [data], names: [name], fileNames: [fileName], params: params, success: success, failure: failure)
    }
    
    /// 上传多文件
    ///
    /// - Parameters:
    ///   - urlString: url
    /// - parameter data:     The data to encode into the multipart form data.
    /// - parameter name:     The name to associate with the data in the `Content-Disposition` HTTP header.
    
    class func upLoadFiles(
        _ urlString: String,
        data: [Data],
        names: [String]? = nil,
        fileNames: [String]? = nil,
        params: Parameters? = nil,
        success: @escaping Success,
        failure: @escaping Failure)
    {
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                assert(names?.count == fileNames?.count, "names.count != fileNames.count There may be problems")
                
                for i in 0..<data.count {
                    let data_name = names?[i] ?? "image\(i)"
                    let file_name = fileNames?[i] ?? "image\(i).png"
                    
                    //"image/png"
                    multipartFormData.append(data[i], withName: data_name ,fileName: file_name, mimeType: "multipart/form-data")
                }
                
                //参数添加
                if let params = params {
                    for (key, value) in params {
                        multipartFormData.append(((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!), withName: key)
                        
                    }
                }
                
        },
            to: urlString,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if let value = response.result.value as? [String: Any]{
                            success(value)
                        }
                    }
                case .failure(let encodingError):
                    failure(encodingError)
                }
            }
        )
        
    }
    
    
}
