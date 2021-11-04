//
//  ViewController.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let sectionInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)

    var gameBoard: [[Int]] = Array(repeating: Array(repeating: 0, count: GameConfig().BoardCellX), count: GameConfig().BoardCellY)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        gameBoard[1][1] = 1
        
        // delegate와 datasource에서 제공하는 메서드를 이용해서 collectionView를 그림
        // 해당 메서드 구현하기 위해 프로토콜 참조하고
        // 해당 delegate, datasource 연결해준다.
        collectionView.delegate = self
        collectionView.dataSource = self
        }



    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GameConfig().BoardCellY
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameConfig().BoardCellX
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if gameBoard[indexPath[0]][indexPath[1]] == 1 {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.gray
        }
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    // Cell 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let blockHorizontalNum = CGFloat(GameConfig().BoardCellX)
        let screenWidth: CGFloat = collectionView.frame.width - blockHorizontalNum // 중간 마진이 1 들어간다. 그래서 마진 개수 만큼 뺀 공간을 구한다.

        let width = screenWidth/blockHorizontalNum
        return CGSize(width: width, height: width)
    }

    // block line 간의 간격 1 띄우기 위해
    // block 좌우간 마진은 1있다.
    // 세로 마진 주기 위한 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets { return sectionInsets }
}
