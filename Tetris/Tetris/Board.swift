//
//  Board.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation

class Board {
    
    // 게임판의 가로 세로 길이 지정
    // 게임판 이중 배열의 크기로 들어갈 것
    let width = GameConfig().BoardSizeX
    let height = GameConfig().BoardSizeY
    
    // 이중 배열의 게임판 선언
    var gameBoard: [[Int]]
    // 움직일 수 있는 블럭 하나를 가진다.
    var block : Block!
    
    // Block 생성시 게임보드 초기화
    init() {
        // GameConfig에 정의한 보드 사이즈 만큼의 보드 이중 배열을 0으로 초기화
        gameBoard = Array(repeating: Array(repeating: 0, count: self.width), count: self.height)
    }
    
    // 게임판에 새로운 블럭 넣어주기
    func addBlock(block: Block) {
        self.block = block
    }
    
    // 블럭 움직인 것에 대한 게임판 다시 그리기
    func insertCurrentBlock() {
        
        // 블럭의 shape 배열을 확인한다.
        for y in block.shape.indices {
            for x in block.shape[y].indices {
                
                if block.shape[y][x] > 0 { // 0이 이상인 실제 값이 있는 곳을 게임판에 넣는다.
                    gameBoard[block.y+y][block.x+x] = block.shape[y][x]
                }
            }
        }
    }
    
    // 게임판에 들어가있는 블럭을 0으로 지운다. (옮기고 다시 그려줄 것)
    func removeCurrentBlock() {
        
        for y in block.shape.indices {
            for x in block.shape[y].indices {
                
                if block.shape[y][x] > 0 {
                    gameBoard[block.y+y][block.x+x] = 0
                }
            }
        }
    }
}
