//
//  Game.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

class Game {
    
    // 게임 상태를 나타낼 enum
    enum GameState { case progress, gameover }
    var gameState: GameState!
    
    // Game에 필요한 객체 선언
    var board : Board!
    var currentBlock : Tetromino!
    var nextBlock : Tetromino!
    
    // Game Level을 표시해줄 변수
    var level: Int
    // Game Score를 표시해줄 변수
    var score: Int
    
    // 움직임에 따라 변화하는 구간 지정 x, y, 숫자든 배열
    var dirtyRect: (Int,Int, Int, Int)!
    
    
    // Game에서 필요한 객체 및 변수 초기화 작업
    init() {
        // 초기 레벨 1, 점수 0으로 설정
        level = 1
        score = 0
        
        // Game에 필요한 board, currentBlock, nextBlock 객체 생성
        board = Board()
        currentBlock = Tetromino()
        nextBlock = Tetromino()
    }
    
    /************************
     Public  Methods
     */
    
    // 제일 처음 게임 시작에 맞춰 값 설정
    // 처음 게임 상태 설정, 첫 블럭 게임판에 넣고 그리기
    func gameStart() {
        // 게임 실행중인 상태 .progress로 설정
        gameState = .progress

        // board에 currentBlock을 넣는다.
        board.addBlock(block: currentBlock)
        
        // 넣은 block을 실제 board의 게임판에 그리는 작업
        board.insertCurrentBlock()
    
    }
    
    // Controller로부터 move 요청이 왔을 때, 실제 block 움직일 코드
    // enum으로 정의해둔 Direction 타입을 인자로 받는다. --> up, autoDown, hardDown, left, right
    func checkMove(direction: MoveDirection) -> (Int, Int, Int, Int)? {
        
        switch direction { // 각각의 direction마다 switch 문으로 실행
        case .up: break
        
        // Game이 진행되며 Timer에 맞춰 자동으로 autoDown으로 블럭이 한 칸씩 내려온다.
        case .autoDown:
            print("autodown")
            // 게임판에 현재 블럭 remove로 0으로 지운다. (지우고 옮기고 valid 검사)
            board.removeCurrentBlock()
            // 블럭의 y 좌표 옮긴다.
            board.block.move(direction: .autoDown)
            
            // validCheck
            if !isValid() {
                // 한 칸 내렸는데 isValid 하지 못하다! 다시 한 칸 up 시키고 그린다.
                board.block.move(direction: .up)
                board.insertCurrentBlock()
                // 더 이상 내려갈 수 없다 - line check, score check한다.
                prepareNext()
//                break
                return (0, 0, GameConfig().BoardSizeX-1, GameConfig().BoardSizeY-1)
            }
            // 실제 게임판에 블럭 값을 넣어 그린다.
            board.insertCurrentBlock()
            
            var endBottom = board.block.y+board.block.shape.count
            if endBottom > GameConfig().BoardSizeY-1 {
                endBottom = GameConfig().BoardSizeY-1
            }
            dirtyRect = (board.block.x, board.block.y-1, board.block.x+board.block.shape[0].count, endBottom)
            
            return dirtyRect
            
        // 사용자가 Down키를 눌렀을 때, hardDown이 실행되며 내려갈 수 있는 최대한의 칸까지 내려간다.
        // 곧장 해당 블럭 끝나고 newBlock 생성
        case .hardDown:
            board.removeCurrentBlock()

            // 블럭을 한 칸씩 내리는 걸 valid하다면 계속 반복
            repeat {
                board.block.move(direction: .autoDown)
            } while isValid()
            
            // valid 하지않으면 한 칸 올리고 그리고 check
            board.block.move(direction: .up)
            board.insertCurrentBlock()
            prepareNext()
            
            dirtyRect = (board.block.x, board.block.y, board.block.x+board.block.shape[0].count, GameConfig().BoardSizeY-1)
            
            return dirtyRect
            
        // 사용자가 Left키를 눌렀을 때, 블럭을 왼쪽으로 한 칸 이동시킨다.
        case .left:
            // 게임판에 현재 블럭 remove로 0으로 지운다. (지우고 옮기고 valid 검사)
            board.removeCurrentBlock()
            // 블럭의 x 좌표 옮긴다.
            board.block.move(direction: .left)
            
            if !isValid() { // 옮긴 블럭이 isValid 하지 않으면 다시 원래 자리로 옮긴다.
                board.block.move(direction: .right)
                return nil
            }
            // 결정된 자리 (옮겼거나, 그대로거나) 게임판에 그리기
            board.insertCurrentBlock()
            
            var endRight = board.block.x+board.block.shape[0].count+1
            if endRight > GameConfig().BoardSizeX-1 {
                endRight = GameConfig().BoardSizeX-1
            }
            dirtyRect = (board.block.x, board.block.y, endRight, board.block.y+board.block.shape.count)
            return dirtyRect

            
        // 사용자가 Right키를 눌렀을 때, 블럭을 오른쪽으로 한 칸 이동시킨다.
        case .right:
            board.removeCurrentBlock()
            board.block.move(direction: .right)
            
            if !isValid() {
                board.block.move(direction: .left)
                return nil
            }
            
            board.insertCurrentBlock()
            
            var endRight = board.block.x+board.block.shape[0].count
            if endRight > GameConfig().BoardSizeX-1 {
                endRight = GameConfig().BoardSizeX-1
            }
            dirtyRect = (board.block.x-1, board.block.y, endRight, board.block.y+board.block.shape.count)
            return dirtyRect
        }
        return nil
    }
    
    // 사용자가 rotate키를 눌렀을 때, 블럭을 시계방향으로 회전 시킨다.
    func rotate() -> (Int, Int, Int, Int)? {
        board.removeCurrentBlock()
        board.block.roatate(direction: .clock)
        
        if !isValid() {
            board.block.roatate(direction: .counterClock)
            return nil
        }
        
        board.insertCurrentBlock()
        
        dirtyRect = (board.block.x, board.block.y, board.block.x+board.block.shape[0].count, board.block.y+board.block.shape.count)
        return dirtyRect
    }
    
    /************************
     Private Methods
     */
    
    // 블럭 옮긴 자리가 Valid 한지 검사
    private func isValid() -> Bool {
        
        // board의 블럭 중 0이 아닌 숫자가 있는 칸만 확인한다.
        for y in board.block.shape.indices {
            for x in board.block.shape[y].indices {
                
                if board.block.shape[y][x] != 0 {
                    
                    // 움직인 블럭이 벽에 닿였는지 확인
                    if board.block.y + y > GameConfig().BoardSizeY - 1 || board.block.x + x > GameConfig().BoardSizeX - 1 || board.block.x + x < 0 {
                        return false
                    }
                    
                    // 움직인 블럭이 다른 블럭과 겹치는지 확인
                    if board.gameBoard[board.block.y + y][board.block.x + x] != 0 {
                        return false
                    }
                }
            }
        }
        // 유효하다 - 해당 블럭 움직일 수 있다.
        return true
    }
    
    // 블럭 움직임이 끝났을 때 check --> line check, score check, add new block
    private func prepareNext() {
        // 몇 개의 line 지울 수 있는지 확인
        let howManyLineClear = checkClearLine()
        
        // 해당 line 수만큼 점수 반영
        checkScore(lineNum: howManyLineClear)
        
        // 새 블럭 생성
        addNewBlock()
    }
    
    // 블럭 하나가 끝나고 나면 한 줄 Line 제거가 가능한지 확인
    // 여러 줄이 가능할 수도 있다. 몇 줄인지에 따라 점수에 반영되니 Int 로 반환한다.
    private func checkClearLine() -> Int {
        // claer 가능한 line 수
        var clearLine = 0
        
        // 한 줄 씩 검사
        for y in board.gameBoard.indices {
            
            var isOccupied = true
            
            for x in board.gameBoard[y].indices {
                
                // 해당 줄에 0이 하나라도 있으면 한 줄 다 찬게 아니다.
                if board.gameBoard[y][x] == 0 {
                    // 해당 줄 지울 수 없다.
                    isOccupied = false
                    break
                }
            }
            
            // 한 줄 검사했는데 0이 없다. - 지울 수 있다.
            if isOccupied {
                clearLine += 1
                // 해당 줄 지운다.
                board.gameBoard.remove(at: y)
                // 제일 위애 빈 라인 추가
                board.gameBoard.insert(Array(repeating: 0, count: GameConfig().BoardSizeX), at: 0)
            }
        }
        
        return clearLine
    }
    
    // 점수 계산
    private func checkScore(lineNum: Int) {
        // 블럭 하나 다 놓았을 때의 블럭 당 점수
        score += GameConfig().BlockScore
        // 블럭 하나 다 놓았을 때 지울 수 있는 라인 당 점수
        score += lineNum * GameConfig().LineScore
        
        
        // GameConfig에서 정의해둔 점수에 맞게 레벨 세팅된다
        for i in 1..<GameConfig().GameScore.count {
            // score가 정의해둔 점수 범위 내에 있을 경우 해당 레벨 설정
            if (GameConfig().GameScore[i-1]...GameConfig().GameScore[i]).contains(score) {
                level = i
                break
            }
        }
    }
    
    // 하나의 블럭 다 놓았을 때, 새로운 블럭 생성
    private func addNewBlock() {
        // 보드의 블럭을 새로운 블럭으로 바꿔준다.
        board.addBlock(block: nextBlock)
        
        // 바꿔준 새로운 블럭에 대한 valid 검사
        if !isValid() {
            // valid 하지 않다면 게임 종료
            self.gameState = .gameover
        }
        
        // valid 하다면 게임판에 새 블럭 그려주고 그 다음의 새 블럭 생성
        board.insertCurrentBlock()
        nextBlock = Tetromino()
    }
}
