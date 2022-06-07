//
//  BaseVC.swift
//  OneSwift
//
//  Created by van on 2017/9/15.
//  Copyright © 2017年 van. All rights reserved.
//UIViewController  基类

import UIKit

enum NaviType{
    case redType
    case whiteType
}

class BaseVC: UIViewController {
    
// MARK: - 属性
    public var  navitype : NaviType = .redType{
        didSet (newValue){
            navitype = newValue
            setNaviAction(type: newValue)
        }
    }
    //返回键
    var backButton :UIButton = UIButton.init(type: UIButton.ButtonType.custom)
    
    // MARK: - 系统
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 248, green: 248, blue: 248, alpha: 1)
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navitype = .redType
    }
    
    // MARK: - 自定义方法
    
    func setNaviAction(type:NaviType) -> () {

        var navTextColorDic :[NSAttributedString.Key : Any] = [:]
        if type == .redType {
            UIApplication.shared.statusBarStyle = .lightContent
            
            self.navigationController?.navigationBar.isTranslucent = false
           navTextColorDic =
            [NSAttributedString.Key.foregroundColor:UIColor.white//设置颜色
             ,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)//设置字体
//            ,NSAttributedStringKey.backgroundColor:UIColor.red//背景色
            ]
            self.navigationController?.navigationBar.barTintColor = UIColor.ColorHex(hex : "0xFF625B")
        }
        else if (type == .whiteType){
            UIApplication.shared.statusBarStyle = .default
            navTextColorDic =
            [NSAttributedString.Key.foregroundColor:UIColor.black//设置颜色
             ,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)//设置字体
                        ]
//            navTextColorDic = [NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = false
        }
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage.init(), for: .any, barMetrics: .default)
        navigationBar?.shadowImage = UIImage.init()
        navigationBar?.titleTextAttributes = navTextColorDic
    }
    
    @objc func baseBack() -> () {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showBack(show : Bool) -> () {
        if(show){
            backButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 44)
            backButton.setImage(UIImage(named : "nav_back"), for: UIControl.State.normal)
            backButton.addTarget(self, action : #selector(baseBack), for: UIControl.Event.touchUpInside)
            backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 10);
            
            let backButtonView : UIView! = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 44))
            backButtonView.addSubview(backButton);
            let backItem : UIBarButtonItem = UIBarButtonItem.init(customView: backButtonView)
            backItem.style = UIBarButtonItem.Style.plain
            self.navigationItem.leftBarButtonItem = backItem;
        }
        else{
             self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        }
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           print("内存泄漏！！！=%@",self);
       }
    
}
