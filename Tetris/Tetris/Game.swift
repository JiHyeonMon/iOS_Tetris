//
//  Game.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation
import UIKit

class Game {
    
    // 게임 상태를 나타낼 enum
    enum GameState { case progress, gameover }
    var gameState: GameState!
    
    // Game에 필요한 객체 선언
    var board : Board!
    var currentBlock : Tetromino!
    var nextBlock : Tetromino!
    
    // Game Level을 표시해줄 변수
    var level: Int
    // Game Score를 표시해줄 변수
    var score: Int
    
    // Game에서 필요한 객체 및 변수 초기화 작업
    init() {
        // 초기 레벨 1, 점수 0으로 설정
        level = 1
        score = 0
        
        // Game에 필요한 board, currentBlock, nextBlock 객체 생성
        board = Board()
        currentBlock = Tetromino()
        nextBlock = Tetromino()
    }
    
    func gameStart() {
        // 게임 실행중인 상태 .progress로 설정
        gameState = .progress

        // board에 currentBlock을 넣는다.
        board.addBlock(block: currentBlock)
        
        // 넣은 block을 실제 board의 게임판에 그리는 작업
        board.reDrawBoard()
    }
    
    // Controller로부터 move 요청이 왔을 때, 실제 block 움직일 코드
    // enum으로 정의해둔 Direction 타입을 인자로 받는다. --> up, autoDown, hardDown, left, right
    func move(direction: Direction) {
        
        switch direction { // 각각의 direction마다 switch 문으로 실행
        case .up: return
        
        // Game이 진행되며 Timer에 맞춰 자동으로 autoDown으로 블럭이 한 칸씩 내려온다.
        case .autoDown:
            
            board.removeBlock()
            board.block.move(direction: .autoDown)
            
            // validCheck
            if !isValid() {
                // down이 isValid하다는 건 다 내려갔다는 것!
                // 한 줄의 라인을 없앨 수 있는지 확인하고 점수계산 후 새로운 블럭을 준비한다.
                board.block.move(direction: .up)
//                board.reDrawBoard()
//                checkScore() // 여기서 checkClear
//                addNewBlock()
                check()
            }
            
            board.reDrawBoard()
            
        // 사용자가 Down키를 눌렀을 때, hardDown이 실행되며 내려갈 수 있는 최대한의 칸까지 내려간다.
        // 곧장 해당 블럭 끝나고 newBlock 생성
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
            check()
            
        // 사용자가 Left키를 눌렀을 때, 블럭을 왼쪽으로 한 칸 이동시킨다.
        case .left:
            board.removeBlock()
            board.block.move(direction: .left)
            
            if !isValid() {
                board.block.move(direction: .right)
            }
            board.reDrawBoard()
            
        // 사용자가 Right키를 눌렀을 때, 블럭을 오른쪽으로 한 칸 이동시킨다.
        case .right:
            board.removeBlock()
            board.block.move(direction: .right)
            
            if !isValid() {
                board.block.move(direction: .left)
            }
            
            board.reDrawBoard()
        }
        
    }
    
    // 사용자가 rotate키를 눌렀을 때, 블럭을 시계방향으로 회전 시킨다.
    func rotate() {
        board.removeBlock()
        board.block.roatate(direction: .clock)
        
        if !isValid() {
            board.block.roatate(direction: .counterClock)
        }
        
        board.reDrawBoard()
    }
    
    private func check() {
        // check Score, check Clear, new Block
        checkScore() // 여기서 checkClear
        if !addNewBlock() {
            return
        }
    }
    
    private func isValid() -> Bool {
        
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
    
    private func checkClear() -> Int {
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
    
    private func checkScore() {
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
    
    
    // currentBlock 배치 끝나고 새로운 테트로미노 생성 후 넣어주기
    private func addNewBlock() -> Bool{
        
        board.addBlock(block: nextBlock)
        if !isValid() {
            gameState = .gameover
            return false
        }
        
        nextBlock = Tetromino()
        return true
    }
}
