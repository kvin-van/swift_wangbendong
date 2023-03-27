//
//  ViewController.swift
//  SwiftStudy
//
//  Created by 王本东 on 21/02/2023.
//

import UIKit

class LGStack {
    var items = [Int]()
    func push(_ item: Int) {
        items.append(item)
    }
}

let vcName : String = "ViewController"

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let equat = Equat()
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "标题"
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        var navTextColorDic :[NSAttributedString.Key : Any] = [:]
        navTextColorDic =
        [NSAttributedString.Key.foregroundColor:UIColor.white//设置颜色
         ,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 22)//设置字体
        ]
        self.navigationController?.navigationBar.titleTextAttributes = navTextColorDic
        
        
        let name =  self.printString(name: vcName)
        
        
        //方法一: 直接初始化一个元组
        let status = ("蓝鸥",["iOS", "HTML5", "Unity"])
        //方法二: 直接写出数据类型
        let newStatus:(String, Array) = ("蓝鸥",["iOS", "HTML5", "Unity"])
        print(newStatus)
        
        //方法一: 直接赋值给常量, 并通过使用标记名来获取对应的值
        let statu:(classRoom:String, couse:Array) = status
        print(statu)
        // ' 不常用方法 '
        var classInfo = statu.classRoom + statu.couse[0] + statu.couse[1]
        print(classInfo)

        //方法二: 通过下标获取元素的值
        var classInfo1 = status.0
        print(classInfo1)

        var classInfo2 = status.0 + status.1[0]
        print(classInfo2)
        
        
        
        
        let lgStack = LGStack()
        lgStack.push(1)
        lgStack.push(30)
        print(lgStack.items)
        
        print(checkIfEqual(_first: 1, _second: 1))
        print(checkIfEqual(_first: "astring", _second: "astring"))
        
        //柯里化函数
        let addTwo = add(2)
        let  result = addTwo(7)
        print(result)
    }
    
    //方法
    func printString(name : String) -> String {
        print("\(vcName) + VC名字")
        
        return "\(vcName) + VC名字"
    }
    
    func checkIfEqual <u : Equatable> (_first : u,_second :u) -> Bool {
        return _first == _second
    }
    
    
    func add(_ num: Int) -> (Int) -> Int {
      return { val in
        return num + val
      }
    }
}

