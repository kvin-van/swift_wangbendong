//
//  ImageScrollView.swift
//  PhoenixDriving
//
//  Created by ZhangHS on 16/7/20.
//  Copyright © 2016年 ZhangHS. All rights reserved.
//

import UIKit

/// 自定义一个类，在类中添加一个方法返回对象类型为NSTimer，使用定时器时就用该对象创建，让NSTimer对这个对象进行强引用，而不对视图控制器进行强引用
class WeakTimerObject: NSObject {
    
    weak var targat: AnyObject?
    var selector: Selector?
    var timer: Timer?
    static func scheduledTimerWithTimeInterval(_ interval: TimeInterval,
                                               aTargat: AnyObject,
                                               aSelector: Selector,
                                               userInfo: AnyObject?,
                                               repeats: Bool) -> Timer {
        let weakObject      = WeakTimerObject()
        weakObject.targat   = aTargat
        weakObject.selector = aSelector
        weakObject.timer    = Timer.scheduledTimer(timeInterval: interval,
                                                                  target: weakObject,
                                                                  selector: #selector(fire),
                                                                  userInfo: userInfo,
                                                                  repeats: repeats)
        return weakObject.timer!
    }
    
    @objc func fire(_ ti: Timer) {
        if let _ = targat {
            _ = targat?.perform(selector!, with: ti.userInfo)
        }
        else {
            timer?.invalidate()
        }
    }
}

class ImageScrollView: UIView, UIScrollViewDelegate {

    fileprivate var scrollView      = UIScrollView()
    fileprivate var pageControl     = UIPageControl()
    
    fileprivate var leftImageView   = UIImageView()
    fileprivate var centerImageView = UIImageView()
    fileprivate var rightImageView  = UIImageView()
    
    fileprivate var currentPage     = 0
    fileprivate var width: CGFloat!
    fileprivate var height: CGFloat!
    fileprivate var timer: Timer?

    /// 滚动方向
    enum RollingDirection : Int {
        case left
        case right
    }
    /// 指示器当前页颜色
    var currentPageIndicatorTintColor:UIColor = .white{
        willSet{
            pageControl.currentPageIndicatorTintColor = newValue
        }
    }
    /// 指示器颜色
    var pageIndicatorTintColor:UIColor = .white{
        willSet{
            pageControl.pageIndicatorTintColor = newValue
        }
    }
    /// 是否自动滚动
    var autoRoll = false {
        willSet {
            if newValue {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    /// 滚动方向
    var direction: RollingDirection = .right {
        willSet {
            stopTimer()
        }
        didSet {
            if autoRoll {
                startTimer()
            }
        }
    }
    /// 间隔时间
    var timeInterval: TimeInterval = 3 {
        willSet {
            stopTimer()
        }
        didSet {
            if autoRoll {
                startTimer()
            }
        }
    }
    /// 图片数组
    var imageArray : [UIImage] = [] {
        willSet {
            stopTimer()
            currentPage = 0
            pageControl.numberOfPages = newValue.count
        }
        didSet {
            updateImageData()
            if autoRoll {
                startTimer()
            }
        }
    }
    
    //MARK: - 初始化
    /// 滚动完成响应事件
    var operate: ((_ page: Int)->())?

    //构建scrollView和pageControl
    func initializeUserInterface() {
        width                                     = self.bounds.size.width
        height                                    = self.bounds.size.height
        scrollView.frame                          = self.bounds
        scrollView.delegate                       = self
        scrollView.contentSize                    = CGSize(width: width * 3, height: height)
        scrollView.isPagingEnabled                  = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceVertical = false
        scrollView.bounces = false
        self.addSubview(scrollView)

        pageControl.frame                         = CGRect(x: 0, y: height - 20, width: width, height: 20)
        pageControl.currentPage                   = 0
        self.addSubview(pageControl)

        let imageViews                            = [leftImageView, centerImageView, rightImageView]
        for index in 0...2 {
            imageViews[index].contentMode = .scaleAspectFit
            imageViews[index].frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            scrollView.addSubview(imageViews[index])
        }
    }

    /**
     自定义构造函数

     - parameter frame:                 frame
     - parameter isAutoRoll:            是否自动滚动
     - parameter rollDirection:         滚动方向
     - parameter timeInt:               滚动时间间隔
     - parameter images:                图片数组
     - parameter scrollCompleteOperate: 滚动完成响应闭包,page为当前页数
     */
    init(frame: CGRect, isAutoRoll: Bool?,   rollDirection: RollingDirection?,  timeInt: TimeInterval?,
         images :Array<Any>, scrollCompleteOperate:((_ page: Int)->())?)
    {
        super.init(frame: frame)
        initializeUserInterface()
        if(images.count>0 && images[0] is UIImage){
            imageArray = images as! [UIImage]
        }
        else{
            //  0..<  必须 连上
            for index in 0..<images.count {
                imageArray.append(UIImage.init(named: "c_item4")!)
                //gcd 子线程
                DispatchQueue.global().async {
                    let url = URL(string: images[index] as! String)!
                    if let imageData = try? Data(contentsOf: url) {  //从网上取数据,属于耗时操作
                        let tmpImage = UIImage(data: imageData as Data)   //二进制数据转换为图片，属于耗时操作
                        DispatchQueue.main.async {  //通知ui刷新
                            self.imageArray[index] = tmpImage!
                        }       
                    }
                }
                //另一种方法
//                let queue = DispatchQueue(label: "com.text.swift")
//                queue.async {
//                var  data = Data()
//                do{
//                    data = try Data.init(contentsOf: URL.init(string: images[index] as! String)!)
//                    self.imageArray[index] = UIImage.init(data: data)!
//                }
//                catch{
//                    print(error)
//                }
//                }
            }
    }
        
        pageControl.numberOfPages = imageArray.count
        if let autoR = isAutoRoll {
            autoRoll = autoR
        }
        if let direct = rollDirection {
            direction = direct
        }
        if let timeI = timeInt {
            timeInterval = timeI
        }
        if let completeOperate = scrollCompleteOperate {
            operate = completeOperate
        }
        //初始化
        updateImageData()
        startTimer()
    }

    //重写父类初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init（coder :)尚未实现")
    }

    deinit {
        stopTimer()
        print("停止定时器")
    }
    
    //MARK:- 定时器
    fileprivate func startTimer() {
        timer = nil
        //调用自定义对象，让timer对其进行强引用，而不对视图控制器强引用
        timer = WeakTimerObject.scheduledTimerWithTimeInterval(timeInterval, aTargat: self, aSelector: #selector(pageRoll), userInfo: nil, repeats: true)
    }

    //关闭定时器
    fileprivate func stopTimer() {
        if let _ = timer?.isValid {
            timer?.invalidate()
            timer = nil
        }
    }

    //定时器触发方法
    @objc fileprivate func pageRoll() {
        switch direction {
        case .left:
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        case .right:
            scrollView.setContentOffset(CGPoint(x: width * 2, y: 0), animated: true)
        }
    }

    //MARK: - UIScrollViewDelegate
    //手动滑动停止调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endScrollAnimation(scrollView.contentOffset.x / width)
    }
    //自动滑动停止调用
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        endScrollAnimation(scrollView.contentOffset.x / width)
    }
    
    //判断向左滑动还是向右滑动
    fileprivate func endScrollAnimation(_ ratio: CGFloat) {
        if ratio < 1 {
            if currentPage == 0 {
                currentPage = imageArray.count - 1
            } else {
                currentPage -= 1
            }
        } else if ratio > 1 {
            if currentPage == imageArray.count - 1 {
                currentPage = 0
            } else {
                currentPage += 1
            }
        }
        updateImageData()
    }

     //MARK: - 核心算法
    fileprivate func updateImageData() {
        if currentPage == 0 {
            leftImageView.image   = imageArray.last
            centerImageView.image = imageArray[currentPage]
            rightImageView.image  = imageArray[currentPage + 1]
        }
        else if currentPage == imageArray.count - 1 {
            leftImageView.image   = imageArray[currentPage - 1]
            centerImageView.image = imageArray[currentPage]
            rightImageView.image  = imageArray.first
        }
        else {
            leftImageView.image   = imageArray[currentPage - 1]
            centerImageView.image = imageArray[currentPage]
            rightImageView.image  = imageArray[currentPage + 1]
        }
        if let completeOperate = operate {
            completeOperate(currentPage)
        }
        
        pageControl.currentPage = currentPage
        scrollView.setContentOffset(CGPoint(x: width, y: 0), animated: false)
    }
    
    
    
    
}

