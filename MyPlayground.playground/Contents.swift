import UIKit

var greeting = "Hello, playground"


func addEightAction(string : String) -> String{
    if string.isEmpty{
        return ""
    }
    
    let end = string.count%8 == 0 ? string.count/8 : string.count/8+1
    for i in 1...end {
        if(i * 8 < string.count){//多了
            print("\(string.dropLast(string.count - i*8).dropFirst((i-1)*8).prefix(8))") //后面去掉多的   减去前面输出过了的 + 8位     //prefix（8）意思是 从0 开始8 位
        }
        else if (i * 8 == string.count){//正好
            print("\(string.dropLast(string.count - i*8).dropFirst((i-1)*8))")
        }
        else if (i * 8 > string.count){//不够
            let zero = "00000000"
            let head = string.dropFirst((i-1)*8).prefix(string.count - (i-1)*8)  //前面去掉输出过的 加上点剩余
            print("\(head + zero.suffix(i*8-string.count))")  //补0
        }
    }
    return ""
}
