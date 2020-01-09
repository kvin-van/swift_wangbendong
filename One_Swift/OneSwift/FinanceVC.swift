//
//  FinanceVC.swift
//  OneSwift
//
//  Created by van on 2017/9/14.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit

class FinanceVC: BaseVC ,UITableViewDelegate,UITableViewDataSource{
 // MARK: - 属性
    var listTableView :UITableView!
    var dataArr : [Dictionary<String,Any>] = []
    
    // MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "社交"
        
        let rightBtn : UIButton = UIButton.init(type: .custom)
        rightBtn.setTitle("朋友圈", for: .normal)
        rightBtn.addTarget(self, action: #selector(goFriendCircleVC), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
        
        
        listTableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: Define_SCREEN_WIDTH, height: Define_SCREEN_HEIGHT), style: .plain)
        listTableView.delegate = self
        listTableView.dataSource = self
        
        
    }
    
    // MARK: - 自定义方法
    @objc func goFriendCircleVC() -> () {
        let friendCircleVC = FriendCircleVC.init()
        friendCircleVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(friendCircleVC, animated: true)
    }
    
    // MARK: - UITableView
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = (Bundle.main.loadNibNamed("SetCell", owner: listTableView, options:nil)?.last as? SetCell)!  //另一种方式
//        let dic : Dictionary = self.dataArr[indexPath.row]
//        cell.setCellView(dic: dic)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   

}
