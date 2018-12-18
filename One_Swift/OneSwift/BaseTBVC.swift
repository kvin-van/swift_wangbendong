//
//  BaseTBVC.swift
//  OneSwift
//
//  Created by van on 2017/9/14.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit

class BaseTBVC: UITabBarController ,UITabBarControllerDelegate{
    // MARK: - 属性
    var tabArr : Array <UIViewController> = [];
    
     // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recommendVC =  RecommendVC()
        recommendVC.tabBarItem.title = "新闻"
        recommendVC.tabBarItem.image = UIImage(named : "tabbar_recommend_dark")
        recommendVC.tabBarItem.selectedImage = UIImage(named : "tabbar_recommend_light")
        let recommendNavi = UINavigationController(rootViewController: recommendVC)
        
        let finaceVC = FinanceVC()
        finaceVC.tabBarItem = UITabBarItem(title: "社交", image: UIImage(named :"tabbar_finance_dark"), selectedImage: UIImage(named:"tabbar_finance_light"))
        let fianceNavi = UINavigationController(rootViewController:finaceVC)
        
        let mineVC = MineVC()
        mineVC.tabBarItem = UITabBarItem(title : "购物" ,image:UIImage(named : "tabbar_mine_dark"), selectedImage : UIImage(named :"tabbar_mine_light"))
        let mineNavi = UINavigationController(rootViewController:mineVC)
        
//        let setVC =  SettingVC.init(nibName: "SettingVC", bundle: Bundle.main)
        let setVC =  SettingVC.init()
        setVC.tabBarItem = UITabBarItem(title : "我的" ,image:UIImage(named : "tabbar_setting_dark"), selectedImage : UIImage(named :"tabbar_setting_light"))
        let setNavi = UINavigationController (rootViewController:setVC)
        
        self.viewControllers = [recommendNavi,fianceNavi,mineNavi,setNavi]
        
        UITabBar.appearance().backgroundColor = UIColor.white
        self.tabBar.shadowImage = UIImage(named : "tabBar_line")
        self.tabBar.backgroundImage = UIImage.init()
        self.tabBar.alpha = 0.9
        
        self.delegate = self;
    }
    
    //属于重写
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem)
    {
        
    }
    
    
    //不属于重写
   func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
