//
//  ViewController.swift
//  OneSwift
//
//  Created by van on 2017/8/25.
//  Copyright © 2017年 van. All rights reserved.
//

import UIKit


var word0 = "hello"{
    willSet(newvalue){
        print(newvalue)
    }
}
let word1 = word0
struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct AlternativeRect {
    
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
    subscript(index:CGFloat) -> CGFloat {
        return CGFloat (multiplier) * CGFloat(index)
    }
}

class ViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let threeTimesTable = TimesTable(multiplier: 3)
        print("six times three is \(threeTimesTable[2])")
        
        var possibleNumber : String = "123"
        possibleNumber =   "hahaha"
        let convertedNumber = Double(possibleNumber)
        print("\(possibleNumber),\(String(describing: convertedNumber))")
        if convertedNumber != nil {
            let int_new = Int(convertedNumber!)
            print(int_new)
        }
        
        let defaultColorName = "red"
        var userDefinedColorName: String? //默认值为 nil
        userDefinedColorName = "koko"
        let colorNameToUse = userDefinedColorName ?? defaultColorName
        print(colorNameToUse)
        
        for character in "Dog?" {
            print(character)
        }
        
        let charters : [Character] = ["a","b","c"]
        var abcStr = String(charters)
        print(abcStr)
        
        let characterssss : Character = "!"
        abcStr.append(characterssss)
        
        for index in abcStr.indices {
            print("\(abcStr[index]) ", "来了")
        }
        
        abcStr.insert(contentsOf: "444", at: abcStr.index(abcStr.startIndex, offsetBy: 1))
        print(abcStr)
        
        let range = abcStr.index(abcStr.startIndex, offsetBy: 1)..<abcStr.index(abcStr.startIndex, offsetBy: 3)
        abcStr.removeSubrange(range)
        
        print(abcStr)
        
        var array1 :Array <Int> = [3,2,3]
        var array2  = array1
        
        
        array1[0] = 1
        array1.insert(0, at: 0)
        array1.remove(at: 3)
        array2.append(2)
        print("\(array1)  \(Unmanaged.passUnretained(array1 as AnyObject).toOpaque())")
        print("\(array2)  \(Unmanaged.passUnretained(array2 as AnyObject).toOpaque())")
        
        word0.append(" haha")
        print("\(word0)  \(Unmanaged.passUnretained(word0 as AnyObject).toOpaque())")
        print("\(word1)  \(Unmanaged.passUnretained(word1 as AnyObject).toOpaque())")
        
        let  a = NSMutableArray(array: [1,2,3])
        print("address : \(Unmanaged.passUnretained(a as AnyObject).toOpaque())") //0x000060000004d620
        let b : NSArray = a
        print("address : \(Unmanaged.passUnretained(b as AnyObject).toOpaque())") //0x000060000004d620
        
        a.insert(4, at: 3)
        print(a) //[1,2,3,4]
        print(b) //[1,2,3,4]

        var dic : [String : String] = [:]
        
        dic["1"] = "yi"
        dic.updateValue("er", forKey: "1")
        dic.removeValue(forKey:"1")
        
        var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
        airports["1"] = "2"
        for (airportCode , airportName) in airports {
            print("\(airportCode) : \(airportName)")
        }
        
        
        let someCharacter: Character = "z"
        switch someCharacter {
        case "a","s":
            print("The first letter of the alphabet")
        case "g" where someCharacter == "g" :
            print("The last letter of the alphabet")
        default:
            print("Some other character")
        }
        if #available(iOS 9, *) {
            // 在 iOS 使用 iOS 10 的 API, 在 macOS 使用 macOS 10.12 的 API
        } else {
            // 使用先前版本的 iOS 和 macOS 的 API
        }
        
        var someInt = 3
        var anotherInt = 107
        swapTwoInts(&someInt, &anotherInt)
        print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
        
        let digitNames = [
            0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
            5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
        ]
        
        let numbers = [16, 58, 510]
        let strings = numbers.map {
            (number) -> String in
            var number = number
            print(number)
            var output = ""
            repeat {
                output = digitNames[number % 10]! + output
                number /= 10
            } while number > 0
            return output
        }
        print(strings)
        
        var things = [Any]()
        things.append(0)
        things.append(0.0)
        things.append(42)
        things.append(3.14159)
        things.append("hello")
        things.append((3.0, 5.0))
        things.append(TimesTable(multiplier: Int(CGFloat(2.33))))
        things.append({ (name: String) -> String in "Hello, \(name)" })
        print(things)
        
        print(ChangeValue(a: 3, b: 4))
    }

    func ChangeValue( a : Int, b :Int) ->(a : Int,b :Int){
        var a = a
        var b = b
        a=a+b
        b=a-b
        a=a-b
        return(a,b)
    }
    
    func makeIncrementer(forIncrement amount: Int) -> (() -> Int) {
        var runningTotal = 0
        func incrementer() -> Int {
            runningTotal += amount
            return runningTotal
        }
        return incrementer
    }
    
    func swapTwoInts<Int>(_ a: inout Int, _ b: inout Int)
    {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

