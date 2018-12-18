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
    var backButton :UIButton = UIButton.init(type: UIButtonType.custom)
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("内存泄漏！！！=%@",self);
    }
    
    // MARK: - 自定义方法
    
    func setNaviAction(type:NaviType) -> () {

        var navTextColorDic :[String : Any] = [:]
        if type == .redType {
            UIApplication.shared.statusBarStyle = .lightContent
            self.navigationController?.navigationBar.isTranslucent = false
            navTextColorDic = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
            self.navigationController?.navigationBar.barTintColor = UIColor.ColorHex(hex : "0xFF625B")
        }
        else if (type == .whiteType){
            UIApplication.shared.statusBarStyle = .default
            navTextColorDic = [NSForegroundColorAttributeName : UIColor.black, NSFontAttributeName : UIFont.systemFont(ofSize: 18.0)]
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.isTranslucent = false
        }
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage.init(), for: .any, barMetrics: .default)
        navigationBar?.shadowImage = UIImage.init()
        navigationBar?.titleTextAttributes = navTextColorDic
    }
    
    func baseBack() -> () {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showBack(show : Bool) -> () {
        if(show){
            backButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 44)
            backButton.setImage(UIImage(named : "nav_back"), for: UIControlState.normal)
            backButton.addTarget(self, action : #selector(baseBack), for: UIControlEvents.touchUpInside)
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 10);
            
            let backButtonView : UIView! = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 44))
            backButtonView.addSubview(backButton);
            let backItem : UIBarButtonItem = UIBarButtonItem.init(customView: backButtonView)
            backItem.style = UIBarButtonItemStyle.plain
            self.navigationItem.leftBarButtonItem = backItem;
        }
        else{
             self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        }
    }
    
    
    

    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
