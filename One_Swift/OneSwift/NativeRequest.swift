//
// NativeRequest.swift
//OneSwift

import Foundation
import UIKit

//typealias是用来为已经存在的类型重新定义名字的,通过命名
public typealias SuccessBlock=(_ esponse:[String:Any])->()
public typealias FalseBlock=(_ error:Error)->()

class NativeRequest:NSObject,URLSessionDelegate,URLSessionDownloadDelegate{
    
    public func requestLoading(urlString:String,params:Dictionary<String,String>?=nil,success:@escaping SuccessBlock,failure:@escaping FalseBlock)
    {
        var request=URLRequest(url:URL(string : urlString)!)
        
        if(params?.count)!>Int(0){
            //设置为POST请求
            request.httpMethod="POST"
            let list=NSMutableArray()
            //拆分字典,subDic是其中一项，将key与value变成字符串
            for subDic in params!{
                let tmpStr="\(subDic.0)=\(subDic.1)"
                list.add(tmpStr)
            }
            //用&拼接变成字符串的字典各项
            let paramStr=list.componentsJoined(by:"&")
            //UTF8转码，防止汉字符号引起的非法网址
            let paraData = paramStr.data(using:String.Encoding.utf8)
            //设置请求体
            request.httpBody=paraData
        }
        else{
            request.httpMethod="GET"
        }
        
        let configuration:URLSessionConfiguration=URLSessionConfiguration.default
        let session:URLSession=URLSession(configuration:configuration)
        let task:URLSessionDataTask = session.dataTask(with:request){
            (data,response,error)->Void in
            
            if error == nil{
                do{
                    let responseData:NSDictionary=try JSONSerialization.jsonObject(with:data!,options:JSONSerialization.ReadingOptions.allowFragments)as!NSDictionary
                    print("response:\(String(describing:response))")
                    print("responseData:\(responseData)")
                }catch{
                    print("catch")
                }
            }
            else{
                print("error:\(String(describing:error))")
            }
        }
        // 启动任务
        task.resume()
    }
    
    public func requestUpload(urlString:String,params:Dictionary<String,String>?=nil,success:@escaping SuccessBlock,failure:@escaping FalseBlock)
    {
        let url = URL(string: urlString)
        //请求
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default, delegate: self,  delegateQueue: nil)
        //下载任务
        let downloadTask : URLSessionDownloadTask  = session.downloadTask(with: request)
        //使用resume方法启动任务
        downloadTask.resume()
    }
    
    //下载代理方法，下载结束
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下载结束")
        //输出下载文件原来的存放目录
        print("location:\(location)")
        //location位置转换
        let locationPath = location.path
        //拷贝到用户目录
        let documnets:String = NSHomeDirectory() + "/Documents/2.jpg" //必须要图片类型一致 否则可能崩溃
//        let documnets:String = "/Users/van/Desktop/swift.jpg"
        //创建文件管理器
        let fileManager = FileManager.default
        try! fileManager.moveItem(atPath: locationPath, toPath: documnets)
        print("new location:\(documnets)")
    }
    
    //下载代理方法，监听下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    {
        //获取进度
        let written = totalBytesWritten
        let total = totalBytesExpectedToWrite
        let pro = written/total
        print("下载进度：\(pro)")
    }
    
    //下载代理方法，下载偏移
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //下载偏移，主要用于暂停续传
    }
    
}

