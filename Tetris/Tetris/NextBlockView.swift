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
    var tile: [[UIImageView]]!
    
    // GameConfig에서 미리 정의해둔 크기의 View를 그리기 위해 사이즈 지정
    let nextBlockViewSize = GameConfig().NextBlockSize
    
    /*******************************
     Initialization
     **/
    // init(frame:) : default initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initLayout()
        
    }
    
    // View 초기화
    // NextBlockView을 구성할 cell imageview를 만들고 이중 배열에 맞게 크기 지정 후 넣어준다.
    private func initLayout() {

        // GameConfig에 정의된 사이즈에 맞게 이중 Array 만들어둔다.
        self.tile = Array(repeating: Array(repeating: UIImageView(), count: nextBlockViewSize), count: nextBlockViewSize)
        
        // NextBlock을 보여줄 뷰를 구성할 ImageView 하나의 사이즈 (정사각형으로 그릴 것)
        let cellSize = GameConfig().NextBlockCellSize

        // 해당 커스텀 뷰의 background 색상은 흰색
        self.backgroundColor = .white

        // 이제 tile 돌면서 각각 cell들의 배경색 지정
        // 사이즈에 맞게 화면에 보일 수 있게 한다.
        for i in 0..<nextBlockViewSize {
            for j in 0..<nextBlockViewSize {
                
                // 색상과 크기, 위치를 지정한 실제 imageView를 tile에 넣어준다.
                let imageView: UIImageView = {
                     let view = UIImageView()
                     view.backgroundColor = UIColor.lightGray
                     view.frame = CGRect(x: j*cellSize+j, y: i*cellSize+i, width: cellSize, height: cellSize)
                     return view
                 }()
                
                tile[i][j] = imageView
                self.addSubview(tile[i][j])

            }
        }
    }
    
}
