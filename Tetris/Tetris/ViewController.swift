//
//  ViewController.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    // 실제 게임 진행할 게임 객체 생성
    var game : Game!
    
    // GameConfig에 정의한 보드 사이즈 만큼의 보드 이중 배열을 0으로 초기화
//    var gameBoard: [[Int]] = Array(repeating: Array(repeating: 0, count: GameConfig().BoardCellX), count: GameConfig().BoardCellY)
//    var board = Board()
    
    // 반복을 위한 RunLoop 생성
    let runLoop = RunLoop.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // delegate와 datasource에서 제공하는 메서드를 이용해서 collectionView를 그림
        // 해당 메서드 구현하기 위해 프로토콜 참조하고
        // 해당 delegate, datasource 연결해준다.
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // init 작업
        // 여기서 초기 화면 그리고 클로저도 전달받아 리프레쉬
        game = Game(reDrawBoardAction: {
            self.collectionView.reloadData()
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 실행
        progress()
    }

    // 게임 실행
    func progress() {
        
        let isRunning = true
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.game.move(direction: Direction.down)
        }
        
        while isRunning {
            runLoop.run(until: Date().addingTimeInterval(0.1))
        }
    }
    

    @IBAction func clickRotate(_ sender: UIButton) {
        game.rotate(direction: Rotate.clock)
    }
    
    @IBAction func clickRight(_ sender: UIButton) {
        game.move(direction: Direction.right)
    }
    
    @IBAction func clickLeft(_ sender: UIButton) {
        game.move(direction: Direction.left)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return GameConfig().BoardCellY
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameConfig().BoardCellX
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // 게임 보드판 그리기
        // 블럭 색상 맞추기
        switch game.board.gameBoard[indexPath[0]][indexPath[1]] {
        case 1: cell.backgroundColor = GameConfig().BlockColor[1]
        case 2: cell.backgroundColor = GameConfig().BlockColor[2]
        case 3: cell.backgroundColor = GameConfig().BlockColor[3]
        case 4: cell.backgroundColor = GameConfig().BlockColor[4]
        case 5: cell.backgroundColor = GameConfig().BlockColor[5]
        case 6: cell.backgroundColor = GameConfig().BlockColor[6]
        case 7: cell.backgroundColor = GameConfig().BlockColor[7]
        default: cell.backgroundColor = UIColor.lightGray
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        return sectionInsets
    }
    
}
