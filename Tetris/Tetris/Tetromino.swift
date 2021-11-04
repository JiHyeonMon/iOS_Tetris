//
//  Tetromino.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation
import UIKit


class Tetromino {

    var x: Int = 0
    var y: Int = 0

    enum Shape{
        case I, O, T, J, L, S, Z

        var color : UIColor {
            switch self {
            case .I:
                return UIColor.cyan
            case .O:
                return UIColor.yellow
            case .T:
                return UIColor.purple
            case .J:
                return UIColor.blue
            case .L:
                return UIColor.orange
            case .S:
                return UIColor.green
            case .Z:
                return UIColor.red
            }
        }

    }
    
    enum Rotate {
        case clock, counterClock
        
//        func rotate() {
//            switch self {
//            case .clock:
//                <#code#>
//            case .counterClock:
//                <#code#>
//            }
//        }
    }

    enum Direction {
        case down, left, right
    }

}
