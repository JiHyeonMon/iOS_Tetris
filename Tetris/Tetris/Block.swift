//
//  Tetromino.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation
import UIKit

enum Tetromino: CaseIterable{
    
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

// 블럭이 회전할 수 있는 방향 값
enum RotateDirection { case clock, counterClock }
// 블럭이 움직일 수 있는 방향 값
enum MoveDirection { case up, autoDown, hardDown, left, right }

class Block {

    // 첫 위치가 게임판의 가운데에 위치할 수 있게 가운데 위치로 고정
    var x: Int = Int(GameConfig().BoardSizeX/2)-1
    var y: Int = 0

    // Block 생성시 랜덤한 모양의 테트로미노 shape을 가진다.
    var shape: [[Int]] = Tetromino.allCases.randomElement()?.shape ?? Tetromino.O.shape

}

extension Block {
    
    // 블럭은 움직일 수 있다.
    // 입력으로 받는 방향에 따라 x, y 좌표 움직임
    func move(direction: MoveDirection) {
        switch direction {
        case .up: y -= 1
        case .autoDown, .hardDown: y += 1
        case .left: x -= 1
        case .right: x += 1 
        }
    }
    
    // 블럭은 회전할 수 있다.
    // 입력으로 받는 방향에 따라 shape 변화
    func roatate(direction: RotateDirection) {
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
