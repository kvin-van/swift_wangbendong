//
//  PSSSegmentControl.swift
//  PSSSegmentControl-Swift
//
//  Created by 山不在高 on 17/5/2.
//  Copyright © 2017年 庞仕山. All rights reserved.
//

import UIKit

typealias PSSClickBlock = (UIButton , NSInteger)->Void

class PSSSegmentControl: UIView,UIScrollViewDelegate ,PSSItemViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 40;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustCell", for: indexPath)
        cell.backgroundColor = UIColor.lightGray
        cell.textLabel?.text = NSString.init(format: "新闻%d", indexPath.row) as String
        cell.imageView?.image = UIImage.init(named: "mine_broker")
        cell.detailTextLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    
    //属性
    var selectedIndex: NSInteger = 0 {
        willSet {
            let item0 = self.itemArray[self.selectedIndex]
            let item1 = self.itemArray[newValue]
            item0.pss_selected = false
            item1.pss_selected = true
            self.scrollTo(index: newValue)
        }
    }
    
    var normalColor = UIColor.darkGray {
        didSet {
            for item in self.itemArray {
                item.pss_normalColor = normalColor
            }
        }
    }
    
    var selectedColor = UIColor.red {
        didSet {
            for item in self.itemArray {
                item.pss_selectedColor = selectedColor
            }
        }
    }
    var pss_duration: CGFloat = 0.1 {
        didSet {
            for item in self.itemArray {
                item.pss_duration = self.pss_duration
            }
        }
    }
    var pss_scale: CGFloat = 1.1 {
        didSet {
            for item in self.itemArray {
                item.pss_scale = self.pss_scale
            }
        }
    }
    
    var pss_margin: CGFloat = 15 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var pss_font: UIFont = UIFont.systemFont(ofSize: 15) {
        didSet {
            for item in self.itemArray {
                item.pss_font = pss_font
            }
            self .layoutSubviews()
        }
    }
    // 点击事件回调
    var clickBlock: PSSClickBlock!
    
    // MARK: 只读属性
    private(set) var itemArray:[PSSItemView] = [PSSItemView]()
    
    // MARK: - 私有属性
    private var titleScrollView: UIScrollView!
    private var titleHeight :CGFloat = 0.00
    private var contentScrollView: UIScrollView!
    fileprivate var gradientLayer: CAGradientLayer!   //梯度图层
    
    // MARK: - 构造方法
    init(frame: CGRect, titleArray: [String], tableViewArray: [UITableViewController]? = nil, headHeight : CGFloat) {
        super.init(frame: frame)
        titleHeight = headHeight
        for i in 0..<titleArray.count {
            let text = titleArray[i]
            let item = PSSItemView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: titleHeight), title: text as NSString, font:self.pss_font)
            item.tag = i
            self.itemArray.append(item)
            item.pss_normalColor = self.normalColor
            item.pss_selectedColor = self.selectedColor
            item.pss_delegate = self
        }
        //标题1
        self.titleScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: frame.width, height: titleHeight))
        self.titleScrollView.showsHorizontalScrollIndicator = false
        self.titleScrollView.backgroundColor = UIColor.white
        self.addSubview(titleScrollView)
        for item in self.itemArray {
            self.titleScrollView.addSubview(item)
        }
        //内容
        self.contentScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: titleHeight, width: frame.width, height: pss_height - titleHeight))
        contentScrollView.isPagingEnabled = true
        contentScrollView.bounces = false
        contentScrollView.isDirectionalLockEnabled = true
        contentScrollView.backgroundColor = UIColor.clear
        contentScrollView.showsHorizontalScrollIndicator = false
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.contentSize = CGSize.init(width: pss_width * CGFloat(titleArray.count), height: pss_height - titleHeight)
        contentScrollView.delegate = self;
        self.addSubview(contentScrollView)
        
        if tableViewArray?.count == titleArray.count{
            for i in 0..<titleArray.count {
               contentScrollView.addSubview((tableViewArray?[i].view)!)
            }
        }
        else{
        for i in 0..<titleArray.count {
            let listTableView = NewsTableView.init(frame: CGRect.init(x: CGFloat(i) * pss_width, y: 0 , width: frame.width, height: pss_height - titleHeight))
            listTableView.tableView.delegate = self
            listTableView.tableView.dataSource = self
            listTableView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustCell")
            contentScrollView.addSubview(listTableView.view)
            }
        }
        self.layoutGradientLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: 重写方法
    override func layoutSubviews() {
        super.layoutSubviews()
        let totalW = self.totalWidth()
        self.titleScrollView.contentSize = CGSize.init(width: totalW > self.pss_width ? totalW : self.pss_width, height: titleHeight)
        self.titleScrollView.bounces = (totalW > self.pss_width)
        
        var margin = (self.pss_width - totalW + self.pss_margin * CGFloat(self.itemArray.count + 1)) / CGFloat(self.itemArray.count + 1)
        var x: CGFloat = totalW <= self.pss_width ? margin : self.pss_margin
        
        margin = x
        for i in 0..<self.itemArray.count {
            let item = self.itemArray[i]
            let wid = item.itemWidth
            item.frame = CGRect.init(x: x, y: 0, width: wid, height: titleHeight)
            x += (wid + margin)
        }
        if let gradientL = gradientLayer {
            gradientL.frame = self.bounds
        }
    }
    
    // MARK: 私有方法
    private func totalWidth() -> CGFloat {
        var totalWid: CGFloat = self.pss_margin
        for item in self.itemArray {
            totalWid += (item.itemWidth + self.pss_margin)
        }
        return totalWid;
    }
    
    private func scrollTo(index: NSInteger) {
        let itemV = self.itemArray[index]
        let centerX = itemV.pss_centerX
        if centerX <= self.pss_width / 2 {
            self.titleScrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
        else if centerX >= self.titleScrollView.contentSize.width - self.pss_width / 2 {
            self.titleScrollView.setContentOffset(CGPoint.init(x: self.titleScrollView.contentSize.width - self.pss_width, y: 0), animated: true)
        }
        else {
            let x = centerX - self.pss_width / 2
            titleScrollView.setContentOffset(CGPoint.init(x: x, y: 0), animated: true)
        }
        //滚动tableview
         self.contentScrollView.setContentOffset(CGPoint.init(x: CGFloat(index) * self.pss_width, y: 0), animated: true)
    }
    
    //梯度图层
    private func layoutGradientLayer() {
        gradientLayer = CAGradientLayer.init()
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0)
        gradientLayer.colors = [
            UIColor.white.cgColor,
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.cgColor
        ]
        let margin = 0.02
        let gradient = 0.05
        let locations = [
            margin,
            margin + gradient,
            1 - (margin + gradient),
            1 - margin
        ]
        gradientLayer.locations = locations as [NSNumber]?
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.selectedIndex = NSInteger(scrollView.contentOffset.x / self.pss_width)
    }
    
    // MARK: - PSSItemViewDelegate
    func clickTitleItem(_ item: PSSItemView, index: NSInteger) {
        self.scrollTo(index: index)
        self.selectedIndex = index
        if let block = self.clickBlock {
            block(item,index)
        }
    }
    
    deinit {
        print("PSSSegmentControll - 被销毁了")
    }
}

// MARK: - extension UIView
extension UIView {
    var pss_x: CGFloat {
        return self.frame.origin.x
    }
    
    var pss_y: CGFloat {
        return self.frame.origin.y
    }
    
    var pss_height: CGFloat {
        get {
            return self.frame.size.height
        }
    }
    
    var pss_width: CGFloat {
        get {
            return self.frame.size.width
        }
    }
    
    var pss_centerX: CGFloat {
        get {
            return self.pss_x + self.pss_width / 2
        }
    }
    var pss_boundsCenter: CGPoint {
        get {
            return CGPoint.init(x: self.pss_width / 2, y: self.pss_height / 2)
        }
    }
}




