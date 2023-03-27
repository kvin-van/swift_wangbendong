//
//  ViewController.swift
//  iTahDoodle
//
//  Created by 王本东 on 2023/3/1.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tabelView : UITableView!
    @IBOutlet weak var insertBtn : UIButton!
    @IBOutlet weak var textFile : UITextField!
    
    let cellIdentifier = "cellID"
    let fileUrl : URL = {  //地址
        let documentUrls = FileManager.default.urls(for:.documentDirectory, in: .userDomainMask)
        let documentUrl = documentUrls.first!
        return documentUrl.appendingPathExtension("todoList.items")
    }()
    //读取本地数据
    var dataArr : Array<String> = [];
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "标题"
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)//必须注册了 不然 崩溃
        if let fileArr = NSArray(contentsOf: fileUrl) as? [String]{  //  需要加 as? [String]   把NSArray  转化成 Array
            dataArr = fileArr
        }
    }

    // MARK: - 方法
    @IBAction func addButtonPressed(_sender : UIButton)
    {
        print("输入\(textFile.text ?? "")")
        
        dataArr.append(textFile.text ?? "空")
        //Array  不能写文件  只有 NSArray  可以写文件
        if !((dataArr as NSArray).write(to: fileUrl, atomically: true)){
            print("写入失败")
        }
        
        tabelView.reloadData()
    }
    
    //UITableViewDataSource
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)  //注册了就不需要 下面   if cell == nil  的判断了
        /*
        var cell : UITableViewCell! = nil   //加叹号 后面省去很对问号
        cell = tableView.dequeueReusableCell(withIdentifier:cellIdentifier, for: indexPath)
        if cell == nil {
            cell = UITableViewCell(style:UITableViewCell.CellStyle.default , reuseIdentifier: cellIdentifier)
        }
         */
        
        cell.textLabel?.text = dataArr[indexPath.row]
        
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 40
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int // Default is 1 if not implemented
    {
        return 1
    }

}

