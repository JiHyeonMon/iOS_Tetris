//
//  ViewController.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import UIKit

class ViewController: UIViewController {
    
    /*************************************
     Data
     */
    
    // View Reference
    // 게임판 collectionView
    @IBOutlet weak var gameBoardCollectionView: UICollectionView!
    // 다음 블럭 보여줄 collectionView
    @IBOutlet weak var nextBlockCollectionView: UICollectionView!
    
    // level, score 보여줄 label
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // 실제 게임 진행할 게임 객체 생성
    var game : Game!
    
    // 반복을 위한 RunLoop, Timer 객체 선언
    let runLoop = RunLoop.current
    var timer: Timer!
        
    
    // LifeCycle Start - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate와 datasource에서 제공하는 메서드를 이용해서 collectionView를 그림
        // 해당 메서드 구현하기 위해 프로토콜 참조하고
        // 해당 delegate, datasource 연결해준다.
        gameBoardCollectionView.delegate = self
        gameBoardCollectionView.dataSource = self
        
        nextBlockCollectionView.delegate = self
        nextBlockCollectionView.dataSource = self
        
        // init 작업 - 실제 게임 데이터를 가진 Game 객체 생성
        game = Game()
        
        // 게임 실행
        game.gameStart() // game내의 테트리스 게임에 필요한 데이터 생성 및 설정
        updateUI()
        
        progress() // Controller에서 game 객체 값을 확인하고 View 업데이트

    }

    // 게임 실행
    // game 객체 값을 확인하고 View 업데이트
    func progress() {
        
        // 1초마다 아래 타이머 실행 (반복 설정)
        timer = Timer.scheduledTimer(withTimeInterval: GameConfig().GameTimer, repeats: true) { _ in
            
            // Action
            self.game.checkMove(direction: MoveDirection.autoDown)
            
            
            // UI Update
            self.updateUI()
            
            // check
            if self.game.gameState == .gameover {
                self.timer.invalidate()
            }

        }
        
        runLoop.add(timer, forMode: .common)
        
    }
    
    // Game Model에서 값 가져와 View 업데이트 
    func updateUI() {
        self.levelLabel.text = String(self.game.level)
        self.scoreLabel.text = String(self.game.score)
        self.gameBoardCollectionView.reloadData()
        self.nextBlockCollectionView.reloadData()
    }
    
    /*
     View에서의 사용자 Event
     */
    @IBAction func clickRotate(_ sender: UIButton) {
        game.rotate()                                   // Block Rotate를 위한 game 객체 rotate 메서드 호출
        self.gameBoardCollectionView.reloadData()       // UI Update
    }
    
    @IBAction func clickRight(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.right)           //
        self.gameBoardCollectionView.reloadData()       // UI Update
    }
    
    @IBAction func clickLeft(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.left)            //
        self.gameBoardCollectionView.reloadData()       // UI Update
    }

    @IBAction func clickHardDown(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.hardDown)        //
        self.gameBoardCollectionView.reloadData()       // UI Update
    }
}

// Storyboard상 collectionView를 그리기 위해 정의
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == gameBoardCollectionView {
            return GameConfig().BoardSizeY
        } else {
            return game.nextBlock.shape.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == gameBoardCollectionView {
            return GameConfig().BoardSizeX
        } else {
            return game.nextBlock.shape.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == gameBoardCollectionView {
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
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NextCell", for: indexPath)

            switch game.nextBlock.shape[indexPath[0]][indexPath[1]] {
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

    }
    
    // UICollectionViewDelegateFlowLayout
    // Cell 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == gameBoardCollectionView {
            let blockHorizontalNum = CGFloat(GameConfig().BoardSizeX)
            let screenWidth: CGFloat = collectionView.bounds.width - blockHorizontalNum // 중간 마진이 1 들어간다. 그래서 마진 개수 만큼 뺀 공간을 구한다.

            let width = screenWidth/blockHorizontalNum
            return CGSize(width: width, height: width)
        } else {
            let blockHorizontalNum = CGFloat(game.nextBlock.shape.count)
            let screenWidth: CGFloat = collectionView.bounds.width - blockHorizontalNum // 중간 마진이 1 들어간다. 그래서 마진 개수 만큼 뺀 공간을 구한다.

            let width = screenWidth/blockHorizontalNum
            return CGSize(width: width, height: width)
        }
        
    }

    // UICollectionViewDelegateFlowLayout
    // block line 간의 간격 1 띄우기 위해
    // block 좌우간 마진은 1있다.
    // 세로 마진 주기 위한 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
        return sectionInsets
    }
    
}
