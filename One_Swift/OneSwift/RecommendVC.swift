//
//  RecommendVC.swift
//  OneSwift
//
//  Created by van on 2017/9/14.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit

class RecommendVC: BaseVC,UIScrollViewDelegate {

    var array : NSArray = []{
        willSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新闻"
        self.navigationController?.isNavigationBarHidden = true
        
        self.addSegmentC()
    }

    // MARK: - 多控件浏览
    let dataArr: [String] = ["理财", "基金","期货","期权"]
    // MARK: 私有属性
    private var segmentC: PSSSegmentControl!
//    private var scrollView: UIScrollView!
    
    // MARK: 私有方法
    private func addSegmentC() {
        let segmentC = PSSSegmentControl.init(frame: CGRect.init(x: 0, y: 20, width: Define_SCREEN_WIDTH, height: Define_SCREEN_HEIGHT - 20 - Define_TabBarHeight), titleArray: dataArr,tableViewArray : nil,headHeight: 44)
        segmentC.pss_font = UIFont.systemFont(ofSize: 15)
        segmentC.pss_margin = 15
        segmentC.normalColor = UIColor.darkGray
        segmentC.selectedColor = UIColor.red
        segmentC.pss_duration = 0.2
        segmentC.pss_scale = 1.3
        segmentC.selectedIndex = 0
        self.view.addSubview(segmentC)
        self.segmentC = segmentC
        
        weak var weakSelf = self
        // segmentC点击事件
        segmentC.clickBlock = {
            (button:UIButton, index: NSInteger) in
//            weakSelf?.scrollView.setContentOffset(CGPoint.init(x: CGFloat(index) * Define_SCREEN_HEIGHT, y: 0), animated: true)
            if weakSelf?.segmentC.selectedIndex == index {
                print("同一个");
            }
        }
    }

}
