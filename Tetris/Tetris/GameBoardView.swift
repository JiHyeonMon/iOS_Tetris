//
//  GameBoardView.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/09.
//

import UIKit

/**
 게임 보드판을 그릴 View를 커스텀하여 생성
 */
class GameBoardView: UIView {
    
    // GameBoardView 구성할 한 칸 한 칸 하나. ImageView로 생성
    var cell: UIImageView!
    // 테트리스 게임 보드판을 UIImageView를 사이즈에 맞게 이중 배열로 만들 것
    var board: [[UIImageView]]!
    
    
    /*******************************
     Initialization
     **/
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initLayout()
        
    }
    
    // View 초기화
    private func initLayout() {
        // 보드판을 구성할 ImageView 하나의 사이즈 (정사각형으로 그릴 것)
        let cellSize = GameConfig().GameBoardCellSize
        
        // 해당 커스텀 뷰의 background 색상은 흰색
        self.backgroundColor = .white
        
        // 데이터 선언
        // UIImageView 하나 만들어 cell에 넣어준다
        self.cell = UIImageView()
        // GameConfig에 정의된 게임보드 판에 맞게 이중 Array 만들어둔다.
        self.board = Array(repeating: Array(repeating: cell, count: GameConfig().BoardSizeX), count: GameConfig().BoardSizeY)
        
        // 이제 board 돌면서 각각 cell들의 배경색 지정
        // 사이즈에 맞게 화면에 보일 수 있게 한다.
        for i in 0..<GameConfig().BoardSizeY {
            for j in 0..<GameConfig().BoardSizeX {
                
                board[i][j].backgroundColor = UIColor.lightGray
                board[i][j].frame = CGRect(x: j*cellSize+j, y: i*cellSize+i, width: cellSize, height: cellSize)
                
                // 색상과 크기 지정 후 실제 SuperView에 넣어 화면에 보이게 한다.
                self.addSubview(board[i][j])
                
            }
        }
    }
    
    /*******************************
     Methods
     **/
    // Model로부터 값을 가진 gameBoard를 받아 View에 그린다.
    func drawGameBoard(gameBoard: [[Int]]) {
        // gameBoard 전체를 반복문을 통해 순회한다.
        for i in gameBoard.indices {
            for j in gameBoard[i].indices {
                
                // 0이면 회색, 숫자가 있다면 해당 테트로미노에 맞는 색상을 지정해서 그려준다.
                if gameBoard[i][j] == 0 {
                    // 기본 보드판 색
                    board[i][j].backgroundColor = UIColor.lightGray
                } else {
                    // 해당 숫자에 맞는 테트로미노 색상 설정
                    board[i][j].backgroundColor = GameConfig().BlockColor[gameBoard[i][j]]
                }
            }
        }
    }
    
}
