//
//  FoodPickerApp.swift
//  FoodPicker
//
//  Created by 王本东 on 2023/3/27.
//

import SwiftUI

@main
struct FoodPickerApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView(selectedFood: .examples.first!)
//            ShapeStyleView()
            FoodListView()
        }
    }
}
