//
//  Extensions.swift
//  FoodPicker
//
//  Created by 王本东 on 2023/3/29.
//

import Foundation
import SwiftUI

//MARK: -   分类
extension View {
    func mainButtonStyle(shape : ButtonBorderShape = .capsule) -> some View{
        self.buttonStyle(.borderedProminent)
        .buttonBorderShape(shape)
        .controlSize(.large)
    }
    
    func roundedRectBackground(radius : CGFloat = 8, fill : some ShapeStyle) -> some View{
        background(RoundedRectangle(cornerRadius: radius))
            .foregroundStyle(fill)
    }
}

extension Animation {
    static let mySpring = Animation.easeInOut(duration: 0.6)
    static let myEase = Animation.easeInOut(duration: 0.4)
}

extension ShapeStyle where Self == Color {
    static var bg : Color {
        Color(.systemBackground)
    }
    static var groupBg : Color {
        Color(.systemGroupedBackground)
    }

}

extension  Color {
    static let bg2 = Color(.secondarySystemBackground)
}


extension AnyTransition { //转场动画
    static let delayInsertionOpacity = Self.asymmetric(insertion:.opacity.animation(.easeInOut(duration: 0.5).delay(0.2)), removal: .opacity.animation(.easeInOut(duration: 0.4)))
}

extension AnyLayout{
    static func userVstack (if condition:Bool,spacing : CGFloat , @ViewBuilder content: @escaping () -> some View) -> some View {
        let layout = condition ? AnyLayout(VStackLayout(spacing: spacing)) : AnyLayout(HStackLayout(spacing: spacing)) // AnyLayout  专门条件排版
        return layout(content)
    }
}
