//
//  Tetromino.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation
import UIKit

enum Block: CaseIterable{
    
    case I, O, T, J, L, S, Z

    var shape: [[Int]] {
        switch self {
        case .I:
            return [[1,1,1,1], [0,0,0,0], [0,0,0,0], [0,0,0,0]]
        case .O:
            return [[2,2],[2,2]]
        case .T:
            return [[0,3,0],[3,3,3], [0,0,0]]
        case .J:
            return [[0,4,0], [0,4,0],[4,4,0]]
        case .L:
            return [[5,0,0], [5,0,0], [5,5,0]]
        case .S:
            return [[6,0,0], [6,6,0], [0,6,0]]
        case .Z:
            return [[0,7,0], [7,7,0], [7,0,0]]
        }
    }
}

enum Rotate {
    case clock, counterClock
}

enum Direction {
    case up, autoDown, hardDown, left, right
}


class Tetromino {

    // 첫 위치가 게임판의 가운데에 위치할 수 있게 가운데 위치로 고정
    var x: Int = Int(GameConfig().BoardCellX/2)-1
    var y: Int = 0

//    var block = Block.allCases.randomElement() ?? .O
    var shape: [[Int]] = Block.allCases.randomElement()?.shape ?? Block.O.shape

}

extension Tetromino {
    
    func move(direction: Direction) {
        switch direction {
        case .up: y -= 1
        case .autoDown, .hardDown: y += 1
        case .left: x -= 1
        case .right: x += 1 
        }
    }
    
    func roatate(direction: Rotate) {
        switch direction {
        case .clock:
            var rotateTetromino = Array(repeating: Array(repeating: 0, count: shape.count), count: shape.count)
            
            for i in shape.indices {
                for j in shape[i].indices {
                    rotateTetromino[i][j] = shape[shape.endIndex-1-j][i]
                }
            }
            self.shape = rotateTetromino
            
        case .counterClock:
            var rotateTetromino = Array(repeating: Array(repeating: 0, count: shape.count), count: shape.count)
            
            
            for i in shape.indices {
                for j in shape[i].indices {
                    rotateTetromino[shape.endIndex-1-j][i] = shape[i][j]
                }
            }
            self.shape = rotateTetromino
        }

    }
}
