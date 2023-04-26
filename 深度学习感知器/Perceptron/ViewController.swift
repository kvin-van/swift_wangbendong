//
//  ViewController.swift
//  Perceptron
//
//  Created by 王本东 on 2023/3/6.
//

import UIKit

class ViewController: UIViewController {

    //MARK: 属性
    
    @IBOutlet weak var andOrSegment: UISegmentedControl!
    
    @IBOutlet weak var resultLab: UILabel!
    
    @IBOutlet weak var x2TxtField: UITextField!
    @IBOutlet weak var x1TxtField: UITextField!
    
    //MARK: 属性
    //误差
    var losses : [Float] = []
    //学习率  控制参数更新的快慢
    let rate : Float = 0.2
    //训练次数
    let n = 100
    //训练集合
    var trainData : [[Float]] = [[0.0,0.0],[0.0,1.0],[1.0,0.0],[1.0,1.0]]
    var tempData  : [[Float]] = []
    
    //真值
    var train_label : [Float] = []  //先不赋值  根据  与或 赋值
    var tempLabel : [Float] = []
    //参数
    var modelW : [Float] = [0.0,0.0,0.0]//3个
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

 //激活函数
    func activation(x : Float) -> Float
    {
        return (x > 0.0 ? 1 : 0.0)
    }
    
    //随机获取样本
    func randomSample() -> ([Float] ,Float) //返回值 1 是样本  2是 真值（ 1或者0）
    {
        if tempLabel.count == 0{
            self.tempData += self.trainData
            self.tempLabel  += self.train_label
        }
        let loc = Int(arc4random())%self.tempData.count
//                   print("\(loc)")
        let data = self.tempData[loc]
        let label = self.tempLabel[loc]
        //去掉数据
        self.tempData.remove(at: loc)
        self.tempLabel.remove(at: loc)
        
        return (data,label)
    }
    
    //训练
    func train(label : [Float])
    {
        //先给train_label 赋值
        self.train_label = label
        //再初始化参数
        for  i in 0..<3{
            let w = self.getRandomNumber()
            modelW[i] = w
        }
        // 迭代训练
        losses.removeAll()
        for i in 0..<n {
            let sample = self.randomSample()
            let result = modelW[1] * sample.0[0] + modelW[2] * sample.0[1] + modelW[2]*1
            let loss = self.activation(x: result) - sample.1
//            print("训练第\(i) 次 loss： \(String(loss))")
            print("训练第\(i) 次 loss： \(String(format: "%.2f",loss))  样本为: \(sample.0) 真值为: \(sample.1)")
            losses.append(loss)
            //更新参数
            for (index,_) in modelW.enumerated(){
                if index == 0{
                    modelW[index] -= self.rate * loss * 1
                }
                else{
                    modelW[index]  -= self.rate * loss * sample.0[index - 1]
                }
            }
        }
    }
    //取0-1之间的随机数
    func getRandomNumber()-> Float
    {
        return Float(arc4random())/Float(RAND_MAX)
    }
    
    //训练
    @IBAction func xunLianAction(_ sender: Any) {
        //判断 与或
        switch andOrSegment.selectedSegmentIndex{
            //与
        case 0 :
            self.train(label: [0.0,0.0,0.0,1.0])
            //或
        case 1:
            self.train(label: [0.0,1.0,1.0,1.0])
        default:
            print("异常")
        }
    }
    
    //测试
    @IBAction func ceshiAction(_ sender: Any) {
        if (x1TxtField.text!.count < 1 || x2TxtField.text!.count < 1) {
            print("有空值")
            return
        }
        
        let x1Value = Float(x1TxtField.text!)
        let x2Value =  Float(x2TxtField.text!)
        let result = modelW[0] * 1 + modelW[1] * x1Value! + modelW[2] * x2Value!
        resultLab.text = "\(self.activation(x: result))"
        print("测试结果:\(self.activation(x: result))")
    }
    
    
    
    
}

