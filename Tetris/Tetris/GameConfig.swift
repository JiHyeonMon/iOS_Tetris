//
//  GameConfig.swift
//  Tetris
//
//  Created by 김지현 on 2021/11/04.
//

import Foundation
import UIKit

class GameConfig{
    
    let BoardCellX = 10
    let BoardCellY = 12
    
    let BlockColor:[UIColor] = [UIColor.lightGray, UIColor.cyan, UIColor.yellow, UIColor.purple, UIColor.blue, UIColor.orange, UIColor.green, UIColor.red]
    
    // seconds
    let GameCounter = [1000, 1, 0.8, 0.75, 0.5, 0.4]
    
    let BlockScore = 10
    let LineScore = 100
}
