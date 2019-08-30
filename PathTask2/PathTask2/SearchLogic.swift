//
//  SearchLogic.swift
//  PathTask2
//
//  Created by Алексей Перов on 8/29/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import Foundation

typealias Position = (x: Int, y: Int)

let placeHolder = 99999

class Maze {
    
    let width: Int
    let height: Int
    let startPoint: Position
    let endPoint: Position

    var nodes: [[Node]] = []
    
    init(width: Int, height: Int, startPoint: Position, endPoint: Position) {
        self.width = width
        self.height = height
        self.startPoint = startPoint
        self.endPoint = endPoint
        
        for _ in 0..<height {
            var final: [Node] = []
            for _ in 0..<width {
                let node = Node()
                node.type = .air
                final.append(node)
            }
            nodes.append(final)
        }
        
        nodes[startPoint.y][startPoint.x].type = .pointA
        nodes[endPoint.y][endPoint.x].type = .pointB
        
        for i in 0..<nodes.count {
            for j in 0..<nodes[i].count {
                nodes[i][j].x = j
                nodes[i][j].y = i
            }
        }
    }

    func addWall(position: Position) {
        nodes[position.y][position.x].type = .obstacle
    }

    func getNeighborForNode(node: Node) -> [Node] {
        let nodex = node.x
        let nodey = node.y
        var finalNodes: [Node] = []
        //CHECK ABOVE
        if nodes.checkIndex(nodey-1) {
            finalNodes.append(nodes[nodey-1][nodex])
        }
        //CHECK BELOW
        if nodes.checkIndex(nodey+1) {
            finalNodes.append(nodes[nodey+1][nodex])
        }
        //CHECK RIGHT
        if nodes[nodey].checkIndex(nodex+1) {
            finalNodes.append(nodes[nodey][nodex+1])
        }
        //CHECK LEFT
        if nodes[nodey].checkIndex(nodex-1) {
            finalNodes.append(nodes[nodey][nodex-1])
        }
        var realFinNode: [Node] = []
        //CHECK IF NEIGHBOOR ISN'T ALREADY IN ARRAY AND IS AISLE
        for i in finalNodes {
            if i.from == nil && i.type != .obstacle {
                realFinNode.append(i)
            }
        }
        return realFinNode
    }
    
    func heuristicCostEstimate(from: Node, to: Node) -> Int {
        return (abs(from.x - to.x) + abs(from.y - to.y)) * 40
    }
    
    func lowestFScore() -> Node {
        var finalNode = Node()
        finalNode.g = placeHolder
        finalNode.h = placeHolder
        for i in nodes {
            for j in i {
                if j.f <= finalNode.f && j.g != -100 {
                    finalNode = j
                }
            }
        }
        return finalNode
    }
    
    func reconstructpath(current: Node) -> [Node] {
        var totalPath: [Node] = [current]
        while let par = totalPath.first!.from {
            totalPath.insert(par, at: 0)
        }
        return totalPath
    }
    
    func a_star(_start: Node, _goal: Node) -> [Node] {
        let start = _start
        let goal = _goal
        var closedSet: [Node] = []
        var openSet: [Node] = [start]
        start.g = 0
        start.h = heuristicCostEstimate(from: start, to: goal)
        while openSet.count != 0 {
            var current = lowestFScore()
            if closedSet.count > 0 && openSet.count > 0 {
                if current == closedSet.last! {
                    current = openSet[0]
                }
            }
            if current == goal {
                return reconstructpath(current: current)
            }
            openSet.removeObjFromArray(current)
            closedSet.append(current)
            for neighbor in getNeighborForNode(node: current) {
                var shouldExecuteIf = true
                if closedSet.contains(neighbor) {
                    shouldExecuteIf = false
                }
                if shouldExecuteIf {
                    var tentative_g_score = 0
                    tentative_g_score = current.g + 10
                    if !openSet.contains(neighbor) || tentative_g_score < neighbor.g {
                        neighbor.from = current
                        neighbor.g = tentative_g_score
                        neighbor.h = heuristicCostEstimate(from: neighbor, to: goal)
                        if !openSet.contains(neighbor) {
                            openSet.append(neighbor)
                        }
                    }
                    nodes[neighbor.y][neighbor.x].type = .exploredPath
                }
            }
        }
        return []
    }
    
    func solve() -> ([[Node]], [Node]) {
        let path = a_star(_start: nodes[startPoint.y][startPoint.x], _goal: nodes[endPoint.y][endPoint.x])
        for i in path {
                nodes[i.y][i.x].type = .path
        }

        return (nodes, path)
    }
    
}
