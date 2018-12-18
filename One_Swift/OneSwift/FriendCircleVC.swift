//
//  FriendCircleVC.swift
//  OneSwift
//
//  Created by van on 2018/3/26.
//  Copyright © 2018年 van. All rights reserved.
//

import UIKit

class FriendCircleVC: BaseVC {

    // MARK: - 属性
    var friendArr : Array<Any>!
    
    @IBOutlet  var friendTV : UITableView!
    
    
    // MARK: - 系统
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendTV.tableHeaderView = (Bundle.main.loadNibNamed("FriendCircleVC", owner: self, options:nil)?.last as? UIView)!
        friendTV.register(UINib(nibName: "FriendCircleCell", bundle: Bundle.main), forCellReuseIdentifier: "friendCell")
        
        friendArr = []
    }
     // MARK: - 自定义方法

    // MARK: - UITableView
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friendArr.count
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCircleCell
//        let dic : Dictionary = self.headArr[indexPath.row]
//        cell.setCellView(dic: dic)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
