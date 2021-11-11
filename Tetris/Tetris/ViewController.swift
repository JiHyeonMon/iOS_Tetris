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
    
    // 화면에 그려줄 게임판을 GameBoardView를 통해 작성
    var gameboardView: GameBoardView!
    // 화면에 그려줄 다음 테트로미노를 NextBlockView를 통해 작성
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
        // 게임에 필요한 객체 생성 및 보드판, 첫 테트로미노 생성
        game.gameStart()
        // 화면에 그릴 Board와 다음 테트로미노를 보여줄 View를 현재 View에 추가하여 그릴 수 있게 한다.
        initGameBoardView()
        initNextBlockView()

        updateUI()
        
        // 게임 진행을 시작한다.
        startGameTimer()

    }

    
    /*************************************
       Event Handlers.
     */
    // Block Rotate를 위한 game 객체 rotate 메서드 호출
    @IBAction func clickRotate(_ sender: UIButton) {
        game.rotate()
        updateGameBoardView()
    }
    
    @IBAction func clickRight(_ sender: UIButton) {
        game.checkMove(direction: MoveDirection.right)
        updateGameBoardView()
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
    
    /**********************************
     Methoed associated view update
     */
    // 테트리스 게임판을 그릴 GameBoardView의 크기 및 위치 지정 후 실제 현재 화면에 add한다.
    private func initGameBoardView() {
        gameboardView = GameBoardView(frame: CGRect(x: 0, y: GameConfig().GameBoardTopMargin, width: Int(UIScreen.main.bounds.width), height: GameConfig().GameBoardCellSize*GameConfig().BoardSizeY+GameConfig().BoardSizeY))
        
        view.addSubview(gameboardView)
    }
    
    // 다음 블럭을 보여줄 view를 그릴 NextBlockView의 크기 및 위치 지정 후 실제 현재 화면에 add한다.
    private func initNextBlockView() {
        nextBlockView = NextBlockView(frame: CGRect(x: GameConfig().NextBlockMargin,
                                                    y: GameConfig().GameBoardCellSize*GameConfig().BoardSizeY+GameConfig().BoardSizeY + GameConfig().GameBoardTopMargin + GameConfig().NextBlockMargin,
                                                    width: GameConfig().NextBlockCellSize*GameConfig().NextBlockSize+GameConfig().NextBlockSize, height: GameConfig().NextBlockCellSize*GameConfig().NextBlockSize+GameConfig().NextBlockSize))
        view.addSubview(nextBlockView)
    }
    
    // Game의 보드판이 바뀜에 따라 실제 View도 없데이트 한다.
    // Game Model의 gameBoard를 가져와 값에 맞게 View update
    private func updateGameBoardView() {
        // gameBoard 전체를 반복문을 통해 순회한다.
        for i in game.board.gameBoard.indices {
            for j in game.board.gameBoard[i].indices {
                
                // 0이면 회색, 숫자가 있다면 해당 테트로미노에 맞는 색상을 지정해서 그려준다.
                if game.board.gameBoard[i][j] == 0 {
                    // 기본 보드판 색
                    gameboardView.board[i][j].backgroundColor = UIColor.lightGray
                } else {
                    // 해당 숫자에 맞는 테트로미노 색상 설정
                    gameboardView.board[i][j].backgroundColor = GameConfig().BlockColor[game.board.gameBoard[i][j]]
                }
            }
        }
        
    }
    
    // Next Block이 바뀜에 따라 실제 View도 없데이트
    private func updateNextBlockView() {
        // 현재 화면에 그려진 NextBlock 지운다.
        removeNextBlock()
        // 새로운 NextBlock을 화면에 그려준다.
        drawNextBlock()
    }
    
    // Next Block이 바뀜에 따라 현재 화면에 그려진 NextBlock 지운다.
    func removeNextBlock() {
        // 전체 4*4 사이즈에 맞게 돌면서 모두 default lightGray 색으로 설정한다.
        for i in 0..<GameConfig().NextBlockSize {
            for j in 0..<GameConfig().NextBlockSize {
                nextBlockView.tile[i][j].backgroundColor = UIColor.lightGray

            }
        }
    }
    
    // 새로운 다음 블럭을 그려준다.
    // Game Model의 NewBlock을 실제 화면에 그린다.
    func drawNextBlock() {
        for i in game.nextBlock.shape.indices {
            for j in game.nextBlock.shape[i].indices {
                if game.nextBlock.shape[i][j] > 0 {
                    nextBlockView.tile[i][j].backgroundColor = GameConfig().BlockColor[game.nextBlock.shape[i][j]]
                }
            }
        }
    }
    
    // Game Model에서 값 가져와 View 업데이트
    private func updateUI() {
        self.levelLabel.text = String(self.game.level)
        self.scoreLabel.text = String(self.game.score)
        updateGameBoardView()
        updateNextBlockView()
    }
}
