//
//  ViewController.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import UIKit

class ViewController: UIViewController {
    
    /*************************************
     Data Initialization
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
        
    
    /*************************************
       Life Cycle Management.
     */
    // LifeCycle Start - Initialization.
    // Actual entry point.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gameboardView = GameBoardView(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 500))
        
        view.addSubview(gameboardView)
        
        // delegate와 datasource에서 제공하는 메서드를 이용해서 collectionView를 그림
        // 해당 메서드 구현하기 위해 프로토콜 참조하고
        // 해당 delegate, datasource 연결해준다.
        gameBoardCollectionView.delegate = self
        gameBoardCollectionView.dataSource = self
        
        nextBlockCollectionView.delegate = self
        nextBlockCollectionView.dataSource = self
        
        // init 작업 - 실제 게임 데이터를 가진 Game 객체 생성
        game = Game()
        
        // 게임 초기화.
        game.gameStart()
        updateUI()
        
        // 게임 진행을 시작한다.
        startGameTimer()

    }

    
    /*************************************
       Event Handlers.
     */
    @IBAction func clickRotate(_ sender: UIButton) {
        game.rotate()                                   // Block Rotate를 위한 game 객체 rotate 메서드 호출
        updateGameboard()
    }
    
    @IBAction func clickRight(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.right)
        updateGameboard()
    }
    
    @IBAction func clickLeft(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.left)
        updateGameboard()
    }

    @IBAction func clickHardDown(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.hardDown)
        updateGameboard()
    }


    /*************************************
      Game flow methods.
     */
    
    private func startGameTimer() {
        // 1초마다 아래 타이머 실행 (반복 설정)
        timer = Timer.scheduledTimer(withTimeInterval: GameConfig().GameTimer, repeats: true) { _ in
            self.progress()
        }
        
        runLoop.add(timer, forMode: .common)
    }
    
    // 게임 실행
    // game 객체 값을 확인하고 View 업데이트
    private func progress() {
        // Action
        self.game.checkMove(direction: MoveDirection.autoDown)
        
        
        // UI Update
        self.updateUI()
        
        // check
        if self.game.gameState == .gameover {
            self.timer.invalidate()
        }
    }
    
    // Game Model에서 값 가져와 View 업데이트
    private func updateUI() {
        self.levelLabel.text = String(self.game.level)
        self.scoreLabel.text = String(self.game.score)
        self.gameBoardCollectionView.reloadData()
        self.nextBlockCollectionView.reloadData()
    }
    
    // GameBoard만 업데이트
    private func updateGameboard() {
        self.gameBoardCollectionView.reloadData()
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
