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
    
    // level, score 보여줄 label
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // 실제 게임 진행할 게임 객체 생성
    var game : Game!
    
    // 반복을 위한 RunLoop, Timer 객체 선언
    let runLoop = RunLoop.current
    var timer: Timer!
    
    var gameboardView: GameBoardView!
    var nextBlockView: NextBlockView!
    
        
    
    /*************************************
       Life Cycle Management.
     */
    // LifeCycle Start - Initialization.
    // Actual entry point.
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // init 작업 - 실제 게임 데이터를 가진 Game 객체 생성
        game = Game()
        
        // 게임 초기화.
        game.gameStart()
        initGameBoardView()
        initNextBlockView()

        
        updateUI()
        
        // 게임 진행을 시작한다.
        startGameTimer()

    }

    
    /*************************************
       Event Handlers.
     */
    @IBAction func clickRotate(_ sender: UIButton) {
        game.rotate()                                   // Block Rotate를 위한 game 객체 rotate 메서드 호출
        updateGameBoardView()
    }
    
    @IBAction func clickRight(_ sender: UIButton) {
        let preTetromino = game.board.block!
        print(preTetromino.x)
        game.checkMove(direction: MoveDirection.right)
//        updateGameBoardView()
        print(game.board.block.x)
        gameboardView.redrawGameBoard(preTetromino: preTetromino, nextTetromino: game.board.block)                    
    }
    
    @IBAction func clickLeft(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.left)
        updateGameBoardView()
    }

    @IBAction func clickHardDown(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.hardDown)
        updateGameBoardView()
        
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
        updateGameBoardView()
        updateNextBlockView()

    }
    
    /**********************************
     수정해서 CustomView Methods
     */
     
    private func initGameBoardView() {
        gameboardView = GameBoardView(frame: CGRect(x: 0, y: 60, width: Int(UIScreen.main.bounds.width), height: GameConfig().GameBoardCellSize * GameConfig().BoardSizeY + GameConfig().BoardSizeY))
        
        view.addSubview(gameboardView)
    }
    
    private func updateGameBoardView() {
        gameboardView.drawGameBoard(gameBoard: game.board.gameBoard)

    }
    
    private func initNextBlockView() {
        nextBlockView = NextBlockView(frame: CGRect(x: 10, y: 40*12+12+60+10, width: 25*4+4, height: 25*4+4))
        view.addSubview(nextBlockView)
    }
    
    private func updateNextBlockView() {
        nextBlockView.removeNextBlock()
        nextBlockView.drawNextBlock(tetromino: game.nextBlock.shape)
    }
}
