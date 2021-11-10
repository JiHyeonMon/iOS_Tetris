//
//  NextBlockView.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/09.
//

import UIKit

/**
 다음 테트로미노를 그릴 View를 커스텀하여 생성
 */
class NextBlockView: UIView {
    
    // NextBlockView를 구성할 한 칸 한 칸 하나. ImageView로 생성
    var cell: UIImageView!
    var tile: [[UIImageView]]!
    
    // GameConfig에서 미리 정의해둔 크기의 View를 그리기 위해 사이즈 지정
    let nextBlockViewSize = GameConfig().NextBlockSize
    
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
    
    private func initLayout() {
        // NextBlock을 보여줄 뷰를 구성할 ImageView 하나의 사이즈 (정사각형으로 그릴 것)
        let cellSize = GameConfig().NextBlockCellSize

        // 해당 커스텀 뷰의 background 색상은 흰색
        self.backgroundColor = .white

        // 데이터 선언
        // UIImageView 하나 만들어 cell에 넣어준다
        self.cell = UIImageView()
        // GameConfig에 정의된 사이즈에 맞게 이중 Array 만들어둔다.
        self.tile = Array(repeating: Array(repeating: cell, count: nextBlockViewSize), count: nextBlockViewSize)
        
        // 이제 tile 돌면서 각각 cell들의 배경색 지정
        // 사이즈에 맞게 화면에 보일 수 있게 한다.
        for i in 0..<nextBlockViewSize {
            for j in 0..<nextBlockViewSize {

                tile[i][j].backgroundColor = UIColor.lightGray
                tile[i][j].frame = CGRect(x: j*cellSize+j, y: i*cellSize+i, width: cellSize, height: cellSize)
                self.addSubview(tile[i][j])

            }
        }
    }
    
    /*******************************
     Methods
     **/
    
    // 새로운 다음 블럭이 생성시 기존의 블럭 지워준다. (사이즈가 4*4로 고정이라 지워주지 않으면 이전 블럭이 계속 남아 사용자에게 보일 수 있다.)
    // 전체 4*4 사이즈에 맞게 돌면서 모두 default lightGray 색으로 설정한다.
    func removeNextBlock() {
        for i in 0..<nextBlockViewSize {
            for j in 0..<nextBlockViewSize {
                tile[i][j].backgroundColor = UIColor.lightGray

            }
        }
    }
    
    // 새로운 다음 블럭을 그려준다.
    // NewBlock을 파라미터로 받아 tile에 그린다.
    func drawNextBlock(tetromino: [[Int]]) {
        for i in tetromino.indices {
            for j in tetromino[i].indices {
                if tetromino[i][j] == 0 {
                    tile[i][j].backgroundColor = UIColor.lightGray
                } else {
                    tile[i][j].backgroundColor = GameConfig().BlockColor[tetromino[i][j]]
                }
            }
        }
    }
    
}
