//
//  NextBlockView.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/09.
//

import UIKit


class NextBlockView: UIView {
    
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
        self.tile = Array(repeating: Array(repeating: block, count: 4), count: 4)
        
        for i in 0..<4 {
            for j in 0..<4 {
                
                let imageView: UIImageView = {
                    let view = UIImageView()
                    view.backgroundColor = UIColor.lightGray
                    view.frame = CGRect(x: j*25+j, y: i*25+i, width: 25, height: 25)
                    return view
                }()
                
                tile[i][j] = imageView
                self.addSubview(tile[i][j])

            }
        }
    }
    
    func removeNextBlock() {
        for i in 0..<4 {
            for j in 0..<4 {
                tile[i][j].backgroundColor = UIColor.lightGray

            }
        }
    }
    
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
