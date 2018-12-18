//
//  NewsTableView.swift
//  OneSwift
//
//  Created by van on 2017/9/29.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit

class NewsTableView: UITableViewController {
    var dataArr :Array<Any> = []
   var myTableView: UITableView!
    
    init(frame: CGRect) {
        super.init(style: .plain)
        myTableView = self.tableView
        myTableView.frame = frame
//        myTableView.delegate = self
//        myTableView.dataSource = self
        //随机颜色
//        myTableView.backgroundColor = UIColor.init(red:CGFloat(arc4random_uniform(255))/CGFloat(255.0), green:CGFloat(arc4random_uniform(255))/CGFloat(255.0), blue:CGFloat(arc4random_uniform(255))/CGFloat(255.0) , alpha: 1)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init（coder :)尚未实现")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 取消注释以下行以保留演示文稿之间的选择
        // self.clearsSelectionOnViewWillAppear = false
        
        // 取消注释以下行以在此视图控制器的导航栏中显示“编辑”按钮。
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 10
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        return 40;
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CustCell", for: indexPath)
//        cell.backgroundColor = UIColor.lightGray
//        cell.textLabel?.text = NSString.init(format: "新闻%d", indexPath.row) as String
//        cell.imageView?.image = UIImage.init(named: "mine_broker")
//        cell.detailTextLabel?.text = "\(indexPath.row)"
//        return cell
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

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
