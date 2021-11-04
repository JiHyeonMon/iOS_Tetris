//
//  Tetromino.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation
import UIKit


class Tetromino {

    // 첫 위치가 게임판의 가운데에 위치할 수 있게 가운데 위치로 고정
    var x: Int = Int(GameConfig().BoardCellX/2)-1
    var y: Int = 0

    enum Block: CaseIterable{
        case I, O, T, J, L, S, Z

        var shape: [[Int]] {
            switch self {
            case .I:
                return [[1,1,1,1]]
            case .O:
                return [[1,1],[1,1]]
            case .T:
                return [[0,1,0],[1,1,1]]
            case .J:
                return [[0,1], [0,1],[1,1]]
            case .L:
                return [[1,0], [1,0], [1,1]]
            case .S:
                return [[1,0], [1,1], [0,1]]
            case .Z:
                return [[0,1], [1,1], [1,0]]
            }
        }
        
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
    }

    enum Direction {
        case down, left, right
    }
    
    var block = Block.allCases.randomElement() ?? .O

}

extension Tetromino {
    
    func move(direction: Direction) {
        switch direction {
        case .down: if y < GameConfig().BoardCellY-block.shape.count { y += 1 }
        case .left: if x > 0 { x -= 1 }
        case .right: x+=1
        }
    }
    
    func rotate(direction: Rotate) {
        switch direction {
        case .clock:
            return
        case .counterClock:
            return
        }
    }
}
