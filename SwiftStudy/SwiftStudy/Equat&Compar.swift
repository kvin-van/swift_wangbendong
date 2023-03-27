//
//  Equat&Compar.swift
//  SwiftStudy
//
//  Created by 王本东 on 27/02/2023.
//

import Foundation

class Equat: NSObject {
    override init() {
        struct Point : Equatable{
            let x : Int
            let y : Int
            
            static func == (lhs: Self, rhs: Self) -> Bool{
                return (lhs.x == rhs.x && lhs.y == rhs.y)
            }
        }
        let a = Point(x: 3, y: 4)
        let b = Point(x: 3, y: 4)
        let z = (a == b)
        print(z)
        
    }
    
}
