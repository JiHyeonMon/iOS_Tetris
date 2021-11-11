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
        
        // initCustomView
        // 화면에 그릴 GameBoardView와 다음 테트로미노를 보여줄 NextBlockView를 현재 View에 추가
        initGameBoardView()
        initNextBlockView()
        
        // 초기 게임 보드 값 화면에 그린다.
        refreshAllGameBoard()

        // Label 값과 NextBlock 그린다.
        updateUI()
        
        // 게임 진행을 시작한다.
        startGameTimer()
    }
    
    /*************************************
       Event Handlers.
     */
    // Block Rotate를 위한 game 객체 rotate 메서드 호출
    @IBAction func clickRotate(_ sender: UIButton) {
        // getDirtyRectIsRotate - 회전했다면 dirtyRect을 반환한다.
        // 회전이 가능해서 회전했다면 바뀐 값 dirtyRect 범위 값을 받아서 refreshDirtyRectGameBoard를 통해 화면에 다시 그려준다.
        if let dirtyRect = game.getDirtyRectIsRotate(){
            // dirtyRect만큼 화면 refresh
            refreshDirtyRectGameBoard(dirtyRect: dirtyRect)
        }
    }
    
    @IBAction func clickRight(_ sender: UIButton) {
        // getDirtyRectIsMovable - 움직였다면 dirtyRect을 반환한다.
        // 움직일 수 있어서 움직였다면 바뀐 값 dirtyRect 범위 값을 받아서 refreshDirtyRectGameBoard를 통해 화면에 다시 그려준다.
        if let dirtyRect = game.getDirtyRectIsMovable(direction: .right){
            // dirtyRect만큼 화면 refresh
            refreshDirtyRectGameBoard(dirtyRect: dirtyRect)
        }
    }
    
    @IBAction func clickLeft(_ sender: UIButton) {
        // getDirtyRectIsMovable - 움직였다면 dirtyRect을 반환한다.
        // 움직일 수 있어서 움직였다면 바뀐 값 dirtyRect 범위 값을 받아서 refreshDirtyRectGameBoard를 통해 화면에 다시 그려준다.
        if let dirtyRect = game.getDirtyRectIsMovable(direction: .left){
            // dirtyRect만큼 화면 refresh
            refreshDirtyRectGameBoard(dirtyRect: dirtyRect)
        }
    }

    @IBAction func clickHardDown(_ sender: UIButton) {
        // getDirtyRectIsMovable - 움직였다면 dirtyRect을 반환한다.
        // 움직일 수 있어서 움직였다면 바뀐 값 dirtyRect 범위 값을 받아서 refreshDirtyRectGameBoard를 통해 화면에 다시 그려준다.
        if let dirtyRect = game.getDirtyRectIsMovable(direction: .hardDown){
            refreshDirtyRectGameBoard(dirtyRect: dirtyRect)
        }
        
        // 하드 드랍시 NextBlock이 바뀌기 때문에 즉각적인 UI update가 필요하다ㅣ
        updateUI()
        
    }


    /*************************************
      Game flow methods.
     */
    
    private func startGameTimer() {
        // 1초마다 아래 타이머 실행 (반복 설정)
        timer = Timer.scheduledTimer(withTimeInterval: GameConfig().GameTimer, repeats: true) { _ in
            self.progress()
        }
        
        // 현재 메인루프에 timer add해서 타이머 실행시켜준다.
        runLoop.add(timer, forMode: .common)
    }
    
    // 게임 실행
    // game 객체 값을 확인하고 View 업데이트
    private func progress() {
        
        // Action
        // getDirtyRectIsMovable - 움직였다면 dirtyRect을 반환한다.
        // 움직일 수 있어서 움직였다면 바뀐 값 dirtyRect 범위 값을 받아서 refreshDirtyRectGameBoard를 통해 화면에 다시 그려준다.
        if let dirtyRect = game.getDirtyRectIsMovable(direction: .autoDown) {
            // dirtyRect만큼 화면 refresh
            refreshDirtyRectGameBoard(dirtyRect: dirtyRect)
        }
        
        // UI Update
        updateUI()
        
        // check
        if game.gameState == .gameover {
            timer.invalidate()
        }
    }
    
    /**********************************
     Methoed associated view update
     */
    // GameBoardView 초기화 및 설정
    private func initGameBoardView() {
        // 테트리스 게임판을 그릴 GameBoardView의 크기 및 위치 지정
        gameboardView = GameBoardView(frame: CGRect(x: 0, y: GameConfig().GameBoardTopMargin, width: Int(UIScreen.main.bounds.width), height: GameConfig().GameBoardCellSize*GameConfig().BoardSizeY+GameConfig().BoardSizeY))
        
        // 현재 view에 add한다.
        view.addSubview(gameboardView)
    }
    
    // NextBlockView 초기화 및 설정
    private func initNextBlockView() {
        // 다음 블럭을 보여줄 view를 그릴 NextBlockView의 크기 및 위치 지정
        nextBlockView = NextBlockView(frame: CGRect(x: GameConfig().NextBlockMargin,
                                                    y: GameConfig().GameBoardCellSize*GameConfig().BoardSizeY+GameConfig().BoardSizeY + GameConfig().GameBoardTopMargin + GameConfig().NextBlockMargin,
                                                    width: GameConfig().NextBlockCellSize*GameConfig().NextBlockSize+GameConfig().NextBlockSize, height: GameConfig().NextBlockCellSize*GameConfig().NextBlockSize+GameConfig().NextBlockSize))
        // 현재 view에 add한다.
        view.addSubview(nextBlockView)
    }
    
    // Game의 보드판이 바뀜에 따라 실제 View도 없데이트 한다.
    // Game Model의 gameBoard를 가져와 값에 맞게 View update
    private func refreshAllGameBoard() {
        // gameBoard 전체를 반복문을 통해 순회한다.
        for i in game.board.gameBoard.indices {
            for j in game.board.gameBoard[i].indices {
                // 해당 숫자에 맞는 테트로미노 색상 설정
                gameboardView.board[i][j].backgroundColor = GameConfig().BlockColor[game.board.gameBoard[i][j]]
            }
        }
    }
    
    // 블럭이 이동함에 따라 수정된 부분만 화면 update
    private func refreshDirtyRectGameBoard(dirtyRect: (startX: Int, startY: Int, endX: Int, endY: Int)) {
        // 수정된 Rect의 좌측상단 xy, 우측하단 xy를 받아 보드판 범위에 맞게 반복문을 통해 돌며 화면 refresh
        for dy in dirtyRect.startY...dirtyRect.endY {
            for dx in dirtyRect.startX...dirtyRect.endX {
                
                // 게임 보드판의 범위에 넘지않는 부분 확인한다.
                if dy <= GameConfig().BoardSizeY-1 && dx <= GameConfig().BoardSizeX-1 && 0 <= dx {
                    gameboardView.board[dy][dx].backgroundColor = GameConfig().BlockColor[game.board.gameBoard[dy][dx]]
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
                // 블럭판 회색으로 칠한다.
                nextBlockView.tile[i][j].backgroundColor = UIColor.lightGray

            }
        }
    }
    
    // 새로운 다음 블럭을 그려준다.
    // Game Model의 NewBlock을 실제 화면에 그린다.
    func drawNextBlock() {
        // NextBlockView 4*4 전체 순회를 통해 확인하고 그린다.
        for i in game.nextBlock.shape.indices {
            for j in game.nextBlock.shape[i].indices {
                // 해당 칸에 맞는 색상을 그려준다.
                nextBlockView.tile[i][j].backgroundColor = GameConfig().BlockColor[game.nextBlock.shape[i][j]]
            }
        }
    }
    
    // Game Model에서 값 가져와 View 업데이트
    private func updateUI() {
        // 현재 레벨과 점수 업데이트 
        self.levelLabel.text = String(self.game.level)
        self.scoreLabel.text = String(self.game.score)
        updateNextBlockView()
    }
}
