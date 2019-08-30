//
//  Node.swift
//  PathTask2
//
//  Created by Алексей Перов on 8/29/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import Foundation

enum BlockType {
    case air, obstacle, pointA, pointB, path, exploredPath, pathLeft, pathUp, pathDown, pathRight
}

class Node {
    
    var type: BlockType = .air
    var x: Int = 0
    var y: Int = 0
    
    var g: Int = -100
    var h: Int = -100
    var f: Int {
        return g + h
    }
    
    var from: Node!
}
