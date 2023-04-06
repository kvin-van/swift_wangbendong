//
//  FoodSubffixWrapper.swift
//  FoodPicker
//
//  Created by 王本东 on 2023/3/29.
//

@propertyWrapper struct Subffix : Equatable{  //@propertyWrapper 属性包装
    var wrappedValue: Double
    private let _subffix : String
    
    init(wrappedValue: Double, _ subffix: String) {
        self.wrappedValue = wrappedValue
        self._subffix = subffix
    }
    var projectedValue : String{   //projectedValue  必须实现
        wrappedValue.formatted() + "\(_subffix)"
    }
}

