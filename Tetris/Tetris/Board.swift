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
    var block : Tetromino!
    
    init() {
        // GameConfig에 정의한 보드 사이즈 만큼의 보드 이중 배열을 0으로 초기화
        gameBoard = Array(repeating: Array(repeating: 0, count: self.width), count: self.height)
    }
    
    // 게임판에 새로운 블럭 넣어주기
    func addBlock(block: Tetromino) {
        self.block = block
    }
    
    // 블럭 움직인 것에 대한 게임판 다시 그리기
    func reDrawBoard() {
        
        for y in block.shape.indices {
            for x in block.shape[y].indices {
                
                if block.shape[y][x] > 0 {
                    gameBoard[block.y+y][block.x+x] = block.shape[y][x]
                }
            }
        }
    }
    
    func removeBlock() {
        for y in block.shape.indices {
            for x in block.shape[y].indices {
                
                if block.shape[y][x] > 0 {
                    gameBoard[block.y+y][block.x+x] = 0
                }
            }
        }
    }
}
