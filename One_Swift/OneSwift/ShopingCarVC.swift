//
//  ShopingCarVC.swift
//  OneSwift
//
//  Created by van on 2018/3/1.
//  Copyright © 2018年 van. All rights reserved.
//

import UIKit

class ShopingCarVC: BaseVC,UITableViewDataSource,UITableViewDelegate {

    // MARK: - 属性
    var db:SQLiteDB!
    private var carArr : Array<Dictionary> = Array<Dictionary<String, Any>>()
    

    @IBOutlet weak var carTableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物车"
        self.showBack(show: true)
//        SQLiteDB_AddAction()
        hand_Action_Find()
        self.perform(#selector(hand_Action_Add), with: nil, afterDelay: 2)
    }
    
    // MARK: - 自定义方法
    func showPerson() {
        let data = db.query(sql: "select * from Person")
        if data.count > 0 {
            //获取最后一行数据显示
            let user = data[data.count - 1]
            showSimpleAlert(title: nil, message: String.init(describing: user["name"]!), superVC: self)
        }
    }
    
    // MARK: - 数据库
    //手写存储
    //添加
    @objc func hand_Action_Add() {
        let user : UserBill = UserBill()
        var tempDictionary : Dictionary<String,Any> = ["id":"1009","name":"名字9","age":5]
//        tempDictionary["image"] = UIImageJPEGRepresentation(UIImage.init(named: "mine_broker")!, 1)旧
        tempDictionary["image"] = UIImage.init(named: "mine_broker")!.jpegData(compressionQuality: 1)
        DispatchQueue.global().async {
            let zhen :Bool = user.dbAdd(dictionary: tempDictionary)
            print(zhen)
        }
    }
    //查找
    func hand_Action_Find() {
        let user : UserBill = UserBill()
        DispatchQueue.global().async {
            self.carArr = user.dbFindAll()
            print(self.carArr)
            DispatchQueue.main.sync {
                self.carTableView.reloadData()
            }
        }
    }
    //删除
    func hand_Action_Delete(dictionary : Dictionary<String, Any> ,index : IndexPath) {
        let user : UserBill = UserBill()
        DispatchQueue.global().async {
            let isGood = user.dbDeleteById(idStr: dictionary["id"] as! String)
            if isGood {
                DispatchQueue.main.sync {
                    self.carArr.remove(at: index.row)
                    self.carTableView.deleteRows(at: [index], with: .fade)
                }
            }
        }
    }
    
    //类库 存储
    func SQLiteDB_AddAction() {
        //获取数据库实例
        db = SQLiteDB.shared
        let bol : Bool = db.openDB()
        print(bol)
        //方式1 不能存储图片
//                var tempDic : Dictionary<String,Any> = ["id":"1002","name":"名字2","age":32]
//                let sql = "insert into Person(id,name,age) values('\(tempDic["id"]!)','\(tempDic["name"]!)',\(tempDic["age"]!))"
//                print("sql: \(sql)")
//                 let result = db.execute(sql: sql)
        //方式2
//        let data = UIImageJPEGRepresentation(UIImage.init(named: "mine_broker")!, 1)!  旧
        let data = UIImage.init(named: "mine_broker")!.jpegData(compressionQuality: 1)!
        let tempArr :Array<Any> = ["1009","名字9",5,data]
        let sql = "insert into Person(id,name,age,image) values(?,?,?,?)"
        print("sql: \(sql)")
        let result = db.execute(sql: sql, parameters: tempArr)
        
        if result == 0 {
            print("存储失败%d",result)
        }
    }
    
    // MARK: - UITableView
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return carArr.count
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let CellID = "ShopingCarCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: CellID)
        }
        
        let dic = carArr[indexPath.row]
        cell?.imageView?.image =  UIImage.init(data: dic["image"] as! Data)
        cell!.textLabel?.text = dic["name"] as? String
        cell!.detailTextLabel?.text = dic["id"] as? String
        return cell!
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    internal func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true;
    }
    
    internal func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?
    {
        return "删除它"
    }
    
    internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
        hand_Action_Delete(dictionary: carArr[indexPath.row], index: indexPath)
        }
    }

}
