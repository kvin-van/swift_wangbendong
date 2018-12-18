//
//  SettingVC.swift
//  OneSwift
//
//  Created by van on 2017/9/14.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit

let ShowLoginNotification = "showloginVC"

class SettingVC: BaseVC,UITableViewDataSource,UITableViewDelegate {
    
     // MARK: - 属性
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var listTableView : UITableView!
    @IBOutlet weak var headView : UIView!
    
    let identifier : String = "ListCell"
    
    lazy var headArr : Array<Dictionary<String, Any>>! = {
        return [["image":"mobile","title":"手机号","tag":"0"],["image":"realName","title":"实名认证","tag":"1"],
                          ["image":"pwdManager","title":"密码管理","tag":"3"],["image":"bankCard","title":"银行卡管理","tag":"4"],
                          ["image":"use_help","title":"使用帮助","tag":"6"],["image":"customerService","title":"联系客服","last":"10106618","tag":"8"]];
    }()
    
    // MARK: - 系统方法
    //xib初始化
    convenience init() {
        var nibNameOrNil = String?("SettingVC")
        //考虑到xib文件可能不存在或被删，故加入判断
        if Bundle.main.path(forResource: nibNameOrNil, ofType: "xib") == nil {
            nibNameOrNil = nil
        }
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    //另一种方式
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的"
        
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor = UIColor.white.cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(showlogin), name: NSNotification.Name(rawValue: ShowLoginNotification), object: nil)
        
        listTableView.register(UINib(nibName: "SetCell", bundle: Bundle.main), forCellReuseIdentifier: identifier)
        
    }
    
    // MARK: - 自定义方法
    //登录
    @IBAction func showlogin() {
    }
    
    // MARK: - UITableView
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return headArr.count
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SetCell
//        let cell = (Bundle.main.loadNibNamed("SetCell", owner: listTableView, options:nil)?.last as? SetCell)!  //另一种方式
        let dic : Dictionary = self.headArr[indexPath.row]
        cell.setCellView(dic: dic)
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    // MARK: - UIScrollView
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.layoutSubViewWhenScroll(offsetY: scrollView.contentOffset.y)
    }
    
    internal func layoutSubViewWhenScroll(offsetY: CGFloat ){
        var rect = CGRect.init(x: 0, y: 0, width: self.headView.bounds.width, height: self.headView.bounds.height)
        rect.origin.y += offsetY
        rect.size.height -= offsetY
        self.headView.frame = rect
    }
    
    
    
    

}
