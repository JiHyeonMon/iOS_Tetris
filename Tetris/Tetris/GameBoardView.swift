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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initLayout()
    }
    
    private func initLayout() {
    
        let block: UIImageView = UIImageView()
        var tile: [[UIImageView]] = Array(repeating: Array(repeating: block, count: GameConfig().BoardSizeX), count: GameConfig().BoardSizeY)

        for i in 0..<12 {
            for j in 0..<10 {
                
                let imageView: UIImageView = {
                    let view = UIImageView()
                    view.backgroundColor = UIColor.lightGray
                    view.frame = CGRect(x: j*40+j, y: i*40+i, width: 40, height: 40)
                    return view
                }()
                
                tile[i][j] = imageView
            }
        }
        self.backgroundColor = .blue
        
        for i in 0..<12 {
            for j in 0..<10 {
                self.addSubview(tile[i][j])

            }
        }
        
        tile[3][7].backgroundColor = UIColor.cyan
        
    }
    
}
