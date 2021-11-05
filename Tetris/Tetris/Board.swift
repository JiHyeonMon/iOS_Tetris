//
//  Board.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation

class Board {
    
    let width = GameConfig().BoardCellX
    let height = GameConfig().BoardCellY
    
    var gameBoard: [[Int]]
    var block : Tetromino
    var blockShape: Block
    
    init() {
        // GameConfig에 정의한 보드 사이즈 만큼의 보드 이중 배열을 0으로 초기화
        gameBoard = Array(repeating: Array(repeating: 0, count: self.width), count: self.height)
        block = Tetromino()
        blockShape = block.block
    }
    
    // 게임판에 새로운 블럭 넣어주기
    func addBlock(block: Tetromino) {
        self.block = block
        blockShape = block.block

    }
    
    // 블럭 움직인 것에 대한 게임판 다시 그리기
    func reDrawBoard() {
        
        for y in blockShape.shape.indices {
            for x in blockShape.shape[y].indices {
                
                if blockShape.shape[y][x] > 0 {
                    gameBoard[block.y+y][block.x+x] = blockShape.shape[y][x]
                }
                
            }
        }
                
    }
    
    func removeBlock() {
        for y in blockShape.shape.indices {
            for x in blockShape.shape[y].indices {
                
                if blockShape.shape[y][x] > 0 {
                    gameBoard[block.y+y][block.x+x] = 0
                }
            }
        }
    }
    
    // 블럭 움직임 유효한지 검사
    func isValid() -> Bool {
        return true
    }
}
