//
//  GameConfig.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import UIKit

class GameConfig{
    
    // 테트리스 판의 가로 세로 블럭 개수
    let BoardSizeX = 10
    let BoardSizeY = 12
    
    // 다음 블럭 보여줄 NextBlock 칸 수
    // 테트로미노의 최대 길이인 4에 맞춰 다음 블럭 view를 보여줌
    let NextBlockSize = 4
    
    // 테트로미노에 맞는 색상 보여주기 위해 UIColor 타입 리스트 선언
    let BlockColor:[UIColor] = [UIColor.lightGray, UIColor.cyan, UIColor.yellow, UIColor.purple, UIColor.blue, UIColor.orange, UIColor.green, UIColor.red]
    
    // 게임 진행에 필요한 타이머 간격 (초)
    let GameTimer: Double = 1
    
    // 점수 계산
    // 블럭 하나 놓을 때마다 10점 점수 
    let BlockScore = 10
    // 게임판의 한 줄을 다 없앴을 경우, 한 줄 점수
    let LineScore = 100
    
    // 점수에 따른 레벨
    let GameScore = [0, 0, 200, 400, 750, 1000, 1200, 1500]
    
    // 실제 화면에 보여질 View를 구성할 Cell Size
    // 게임판을 구성할 cell 사이즈
    let GameBoardCellSize = 40
    // 다음 블럭을 보여줄 NextBlock view를 구성할 cell 사이즈
    let NextBlockCellSize = 25
}
