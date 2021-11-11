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
    // 보드판을 구성할 cell imageview를 만들고 보드의 이중 배열에 맞게 크기 지정 후 넣어준다.
    private func initLayout() {
        
        // GameConfig에 정의된 게임보드 판에 맞게 이중 Array 만들어둔다.
        self.board = Array(repeating: Array(repeating: UIImageView(), count: GameConfig().BoardSizeX), count: GameConfig().BoardSizeY)
        
        // 보드판을 구성할 ImageView 하나의 사이즈 (정사각형으로 그릴 것)
        let cellSize = GameConfig().GameBoardCellSize
        
        // 해당 커스텀 뷰의 background 색상은 흰색
        self.backgroundColor = .white
        
        // 이제 board 돌면서 각각 cell들의 배경색 지정
        // 사이즈에 맞게 화면에 보일 수 있게 한다.
        for i in 0..<GameConfig().BoardSizeY {
            for j in 0..<GameConfig().BoardSizeX {
                
                // 색상과 크기, 위치를 지정한 실제 imageView를 보드판에 넣어준다.
                let imageView: UIImageView = {
                     let view = UIImageView()
                     view.backgroundColor = UIColor.lightGray
                     view.frame = CGRect(x: j*cellSize+j, y: i*cellSize+i, width: cellSize, height: cellSize)
                     return view
                 }()
                
                board[i][j] = imageView
                
                // 색상과 크기 지정 후 실제 SuperView에 넣어 화면에 보이게 한다.
                self.addSubview(board[i][j])
                
            }
        }
    }
    
}
