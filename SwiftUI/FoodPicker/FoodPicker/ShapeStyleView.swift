//
//  ShapeStyleView.swift
//  FoodPicker
//
//  Created by 王本东 on 2023/3/29.
//

import Foundation
import SwiftUI
//ShapeStyleView形状样式视图
struct ShapeStyleView : View{
    var body : some View{
        ZStack{
//            Circle().fill(.yellow)
            Circle().fill(.image(.init("aboutIcon"),scale:  1.5))//scale 缩放
            Text("hello").font(.system(size: 100).bold())
                .foregroundStyle(.linearGradient(colors: [.pink,.indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                .background{   //在外面加 .什么  和{}里面添加内容完全不同
                    Color.bg2.scaleEffect(x:1.5,y:1.2).blur(radius: 20) //blur 模糊
                }
        }.background(.cyan)//cyan青色
    }
}
