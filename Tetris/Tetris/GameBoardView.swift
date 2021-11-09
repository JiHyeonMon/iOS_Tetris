//
//  GameBoardView.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/09.
//

import UIKit

/**
 
 
 
 */
class GameBoardView: UIView {
    
    var block: UIImageView!
    var tile: [[UIImageView]]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
        

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initLayout()
        
    }
    
    private func initLayout() {
    
        self.backgroundColor = .white

        self.block = UIImageView()
        self.tile = Array(repeating: Array(repeating: block, count: GameConfig().BoardSizeX), count: GameConfig().BoardSizeY)
        
        for i in 0..<12 {
            for j in 0..<10 {
                
                let imageView: UIImageView = {
                    let view = UIImageView()
                    view.backgroundColor = UIColor.lightGray
                    view.frame = CGRect(x: j*40+j, y: i*40+i, width: 40, height: 40)
                    return view
                }()
                
                tile[i][j] = imageView
                self.addSubview(tile[i][j])

            }
        }
    }
    
    func drawGameBoard(gameBoard: [[Int]]) {
        for i in gameBoard.indices {
            for j in gameBoard[i].indices {
                if gameBoard[i][j] == 0 {
                    tile[i][j].backgroundColor = UIColor.lightGray
                } else {
                    tile[i][j].backgroundColor = GameConfig().BlockColor[gameBoard[i][j]]
                }
            }
        }
    }
    
}
