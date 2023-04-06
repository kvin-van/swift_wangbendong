//
//  Food.swift
//  FoodPicker
//
//  Created by 王本东 on 2023/3/28.
//

import Foundation



struct Food : Equatable,Identifiable{ //可识别
    var id = UUID()
    
    var name : String
    var image: String
    @Subffix("大卡") var calorie :  Double = .zero
    @Subffix("g") var carb : Double  = .zero //碳水化物
    @Subffix("g")  var fat : Double    = .zero
    @Subffix("g")  var protein : Double = .zero //蛋白质
    
    
    static let examples = [
        Food(name: "汉堡", image: "🍔", calorie: 294, carb: 15, fat: 27, protein: 170),
        Food(name: "沙拉", image: "🥗", calorie: 222, carb: 15, fat: 30, protein: 70),
        Food(name: "披萨", image: "🍕", calorie: 394, carb: 25, fat: 87, protein: 160),
        Food(name: "鸡腿便当", image: "🍗🍱", calorie: 290, carb: 45, fat: 27, protein: 70),
        Food(name: "牛肉拉面", image: "🐮🍜", calorie: 94, carb: 115, fat: 7, protein: 370),
        Food(name: "香蕉", image: "🍌", calorie: 24, carb: 215, fat: 127, protein: 10),
        Food(name: "芒果", image: "🥭", calorie: 234, carb: 25, fat: 27, protein: 130),
        Food(name: "寿司", image: "🍣", calorie: 24, carb: 15, fat: 17, protein: 150)
    ]
    //static 静态属性才有新的ID UUID
    static var newFood : Food {
        Food(name: "", image: "")
    }
}
