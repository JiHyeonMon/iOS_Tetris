//
//  Game.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation
import UIKit

class Game {
    
    enum State {
        case progress, gameover
    }
    
    var gameState: State
    // move 클릭 들어오면
    // isvalid
    // actual move
    // redraw
    
    var board = Board()
    var currentBlock : Tetromino!
    var nextBlock : Tetromino!
    
    var level: Int
    var score: Int
    
    // closure 받기
    // 맨 처음 화면 그리기!!
    init() {
        level = 1
        score = 0
        gameState = .progress
        
        currentBlock = Tetromino()
        nextBlock = Tetromino()
        
        board.addBlock(block: currentBlock)
        board.reDrawBoard()
    
    }
    
    func addNewBlock() {
        board.addBlock(block: nextBlock)
        
        if !isValid() {
            self.gameState = .gameover
            return
        }
        nextBlock = Tetromino()
    }
    
    func move(direction: Direction) {
        switch direction {
        case .up: return
        case .autoDown:
            board.removeBlock()
            board.block.move(direction: .autoDown)
            
            // validCheck
            if !isValid() {
                // new block
                // check score, check line
                board.block.move(direction: .up)
                board.reDrawBoard()
                checkScore() // 여기서 checkClear
                addNewBlock()
            }
            
            board.reDrawBoard()
            
        case .hardDown:
            while true {
                board.removeBlock()
                board.block.move(direction: .autoDown)

                if !isValid(){
                    break
                }
            }
            board.block.move(direction: .up)
            board.reDrawBoard()
            checkScore() // 여기서 checkClear
            addNewBlock()

            
        case .left:
            board.removeBlock()
            
            board.block.move(direction: .left)
            
            if !isValid() {
                board.block.move(direction: .right)
            }
            board.reDrawBoard()
            
        case .right:
            board.removeBlock()
            board.block.move(direction: .right)
            
            if !isValid() {
                board.block.move(direction: .left)
            }
            board.reDrawBoard()
        }
        
    }
    
    func rotate() {
        board.removeBlock()
        
        board.block.roatate(direction: .clock)
        
        if !isValid() {
            board.block.roatate(direction: .counterClock)
        }
        
        board.reDrawBoard()
        
    }
    
    func isValid() -> Bool {
        
        for y in board.block.shape.indices {
            for x in board.block.shape[y].indices {
                
                if board.block.shape[y][x] != 0 {
                    
                    if board.block.y + y > GameConfig().BoardCellY - 1 || board.block.x + x > GameConfig().BoardCellX - 1 || board.block.x + x < 0 {
                        return false
                    }
                    
                    // 다른 블럭 체크
                    if board.gameBoard[board.block.y + y][board.block.x + x] != 0 {
                        return false
                    }
                }
            }
        }
        
        // 유효하다
        // 해당 블럭 움직일 수 있다.
        return true
    }
    
    func checkClear() -> Int {
        var clearLine = 0
        
        for y in 0..<GameConfig().BoardCellY {
            
            var isOccupied = true
            
            for x in 0..<GameConfig().BoardCellX {
                
                if board.gameBoard[y][x] == 0 {
                    isOccupied = false
                    break
                }
            }
            
            if isOccupied {
                clearLine += 1
                board.gameBoard.remove(at: y)
                board.gameBoard.insert(Array(repeating: 0, count: GameConfig().BoardCellX), at: 0)
            }
        }
        
        return clearLine
    }
    
    func checkScore() {
        score += GameConfig().BlockScore
        score += checkClear()*GameConfig().LineScore
        
        switch score {
        case 0..<200:
            level = 1
        case 100..<400:
            level = 2
        case 400..<750:
            level = 3
        case 750..<1000:
            level = 4
        default:
            level = 5
        }
        
    }
}
