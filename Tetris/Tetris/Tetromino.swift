//
//  Tetromino.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation

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
    
    mutating func rotate() -> [[Int]] {
        var rotateTetromino = Array(repeating: Array(repeating: 0, count: shape.count), count: shape.count)
        for i in shape.indices {
            for j in shape[i].indices {
                rotateTetromino[i][j] = shape[shape.endIndex-1-j][i]
            }
        }
        return rotateTetromino
    }

}

enum Rotate {
    case clock, counterClock
}

enum Direction {
    case up, down, left, right
}


class Tetromino {

    // 첫 위치가 게임판의 가운데에 위치할 수 있게 가운데 위치로 고정
    var x: Int = Int(GameConfig().BoardCellX/2)-1
    var y: Int = 0

    var block = Block.allCases.randomElement() ?? .O

}

extension Tetromino {
    
    func move(direction: Direction) {
        switch direction {
        case .up: y -= 1
        case .down: y += 1 
        case .left: x -= 1
        case .right: x += 1 
        }
    }
    
//    func roatate() {
//        block.shape = block.rotate()
//    }
}

/*
 fun rotate() {
     // 회전한 테트로미노를 넣을 배열 새로 만든다.
     val rotateTetromino = Array(shape.size) { Array(shape.size) { 0 } }

     // 시계방향으로 새로운 배열에 기존 값 넣는다.
     // 012     630
     // 345  -> 741
     // 678     852
     for (i in shape.indices) {
         for (j in shape[i].indices) {
             rotateTetromino[i][j] = shape[shape.size - 1 - j][i]
         }
     }

     // 회전한 테트로미노를 기존 모양에 넣어준다.
     shape = rotateTetromino
 }
 */
