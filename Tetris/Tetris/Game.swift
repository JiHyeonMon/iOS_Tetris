//
//  Game.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation
import UIKit

class Game {
    
    var board = Board()
    
    // view controller에 있는 collectionView 액션 위한 클로저
    typealias ReDrawBoardAction = () -> Void
    var reDrawBoardAction: ReDrawBoardAction?
    
    // move 클릭 들어오면
    // isvalid
    // actual move
    // redraw
    
    // closure 받기
    // 맨 처음 화면 그리기!!
    init(reDrawBoardAction: @escaping ReDrawBoardAction) {
        self.reDrawBoardAction = reDrawBoardAction
        board.reDrawBoard()
        reDrawBoardAction()
    }
    
    func move(direction: Direction) {
        switch direction {
        case .up: return
        case .down:
            board.removeBlock()
            board.block.move(direction: .down)

            // validCheck
            if !isValid() {
                // new block
                board.block.move(direction: .up)
                board.reDrawBoard()
                board.addBlock(block: Tetromino())
            }
            
            board.reDrawBoard()
            reDrawBoardAction?()
            
        case .left:
            board.removeBlock()
            
            board.block.move(direction: .left)
            
            if !isValid() {
                board.block.move(direction: .right)
            }
            board.reDrawBoard()
            reDrawBoardAction?()
            
        case .right:
            board.removeBlock()
            board.block.move(direction: .right)
            
            if !isValid() {
                board.block.move(direction: .left)
            }
            board.reDrawBoard()
            reDrawBoardAction?()
        }
        
    }
    
    func rotate(direction: Rotate) {
        switch direction {
        case .clock:
//            board.block.block.rotate()
            return
        case .counterClock:
            return
        }
    }
    
    func isValid() -> Bool {
        
        for y in board.blockShape.shape.indices {
            for x in board.blockShape.shape[y].indices {
                
                if board.blockShape.shape[y][x] != 0 {
                    
                    if board.block.y + y > GameConfig().BoardCellY - 1 || board.block.x + x > GameConfig().BoardCellX - 1 || board.block.x < 0 {
                        return false
                    }
                    
                    // 다른 블럭 체크
                    if board.gameBoard[board.block.y + y][board.block.x + x] != 0 {
                        return false
                    }
                    
                    //if y < GameConfig().BoardCellY - block.shape.endIndex { y += 1 }
                    //if x < GameConfig().BoardCellX - block.shape[0].endIndex { x += 1 }
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
                clearLine+=1
                board.gameBoard.remove(at: y)
                board.gameBoard.insert(Array(repeating: 0, count: GameConfig().BoardCellX), at: 0)
            }
        }
        
        return clearLine
    }
    
    
}
