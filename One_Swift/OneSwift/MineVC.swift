//
//  MineVC.swift
//  OneSwift
//
//  Created by van on 2017/9/14.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit


class MineVC: BaseVC {
    
     // MARK: - 属性
let native : NativeRequest = NativeRequest()
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物"
        
        let rightBtn : UIButton = UIButton.init(type: .custom)
        rightBtn.setTitle("购物车", for: .normal)
        rightBtn.addTarget(self, action: #selector(MineVC.goShopingCarVC), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        var array = Array<Any>()
        //        (0...4).forEach {
        //            array.append(UIImage(named: "c_item\($0)")!)
        //        }
        array.append("https://static.xiangqianjinfu.com/xiangqian/upload/images/app/banner/2017/06/20170613145236418.png")
        array.append("https://static.xiangqianjinfu.com/xiangqian/upload/images/app/banner/2017/03/20170313184331802.jpg")
        array.append("https://static.xiangqianjinfu.com/xiangqian/upload/images/app/banner/2017/03/20170313184348339.jpg")
        array.append("https://static.xiangqianjinfu.com/xiangqian/upload/images/app/banner/2017/07/20170714181521195.jpg")
        
        let imageRollView = ImageScrollView(frame: CGRect(x: 0, y: 0, width: Define_SCREEN_WIDTH, height: 140),
                                            isAutoRoll: true,
                                            rollDirection: .right,
                                            timeInt: 4,
                                            images: array) { (page) in
                                                //                                                print("第\(page)页")
        }
        self.view.addSubview(imageRollView)
        
//        var dic : Dictionary = ["ecifId":"CR20170901217081","mobile":Singleton.shareInstance().mobile,"userRegId": Singleton.shareInstance().userRegId, "pid" : getDeviceUUID()] as [String : Any]
//        dic["pid"] = "A2BB8D1F-4107-4BDD-91EA-EDCF00552F8D"
//        self.getMassage(dic: dic)
        
//        self.downloadPictrue(string: "https://static.xiangqianjinfu.com/xiangqian/upload/images/app/banner/2017/07/20170714181521195.jpg")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - 自定义方法
    @objc func goShopingCarVC() -> () {
        let shopingCarVC = ShopingCarVC.init(nibName: "ShopingCarVC", bundle: Bundle.main)
        shopingCarVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(shopingCarVC, animated: true)
    }
    
    func getMassage(dic : Dictionary<String, Any>) -> () {
        
        NIRequest.postRequest(Http_QueryMyWealth, params: dic, success: { (data) in
            showAlert(title: "提示", message: data["errorDesc"] as? String, superVC: self, backBlock: { (tag) in
                print(tag)
            })
        }) { (error) in
            
        }
    }
    
    func  downloadPictrue(string : String){
        native.requestUpload(urlString: string, params: nil, success: { (dic) in
         
        }) { (error) in
            
        }
    }
    
    
}
