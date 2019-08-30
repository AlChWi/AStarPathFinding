//
//  ViewController.swift
//  PathTask2
//
//  Created by Алексей Перов on 8/29/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var endY: UITextField!
    @IBOutlet weak var endX: UITextField!
    @IBOutlet weak var startY: UITextField!
    @IBOutlet weak var startX: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func findPath(_ sender: Any) {
        let widthFromTextField = Int(widthTextField.text ?? "0") ?? 0
        let heightFromTextField = Int(heightTextField.text ?? "0") ?? 0
        let wayOutPositionX = Int(endX.text ?? "0") ?? 0
        let wayOutPositionY = Int(endY.text ?? "0") ?? 0
        let wayOutPosition: Position = (wayOutPositionX, wayOutPositionY)
        let startPositionX = Int(startX.text ?? "0") ?? 0
        let startPositionY = Int(startY.text ?? "0") ?? 0
        let startPosition: Position = (startPositionX, startPositionY)
        let input = textView.text?.split(separator: "\n") ?? []
        print(input)
        var inputStrings = [String]()
        for item in input {
            inputStrings.append(String(item))
        }
        print(inputStrings)
        var input2D = [[String]]()
        for item in 0..<inputStrings.count {
            let row = inputStrings[item].split(separator: " ")
            var rowStrings = [String]()
            for item in row {
                rowStrings.append(String(item))
            }
            print(row)
            input2D.append(rowStrings)
        }
        print(input2D)
        
        let maze = Maze(width: widthFromTextField, height: heightFromTextField, startPoint: startPosition, endPoint: wayOutPosition)
        for (index, element) in input2D.enumerated() {
            for (innerIndex, innerElement) in element.enumerated() {
                print(innerElement)
                if innerElement == "1" {
                    maze.addWall(position: (innerIndex, index))
                    print("adding wall to point \((innerIndex, index))")
                }
            }
        }
        var stringToDisplay = ""

        let (way, path) = maze.solve()
        
        if path.count > 0 {
            for (index, element) in path.enumerated() {
                print(element.x, element.y)
                if index != 0 {
                    if path[index].x > path[index - 1].x {
                        path[index].type = .pathRight
                    }
                    if path[index].x < path[index - 1].x {
                        path[index].type = .pathLeft
                    }
                    if path[index].y > path[index - 1].y {
                        path[index].type = .pathDown
                    }
                    if path[index].y < path[index - 1].y {
                        path[index].type = .pathUp
                    }}
            }
            
            path[0].type = .pointA
            path[path.count-1].type = .pointB
            
            for (index, element) in way.enumerated() {
                for (innerIndex, innerElement) in element.enumerated() {
                    if innerElement.type == .air {
                        stringToDisplay.append("A ")
                    }
                    if innerElement.type == .obstacle {
                        stringToDisplay.append("O ")
                    }
                    if innerElement.type == .pointA {
                        stringToDisplay.append("S ")
                    }
                    if innerElement.type == .pointB {
                        stringToDisplay.append("F ")
                    }
                    if innerElement.type == .exploredPath {
                        stringToDisplay.append("A ")
                    }
                    if innerElement.type == .pathDown {
                        stringToDisplay.append("D ")
                    }
                    if innerElement.type == .pathUp {
                        stringToDisplay.append("U ")
                    }
                    if innerElement.type == .pathLeft {
                        stringToDisplay.append("L ")
                    }
                    if innerElement.type == .pathRight {
                        stringToDisplay.append("R ")
                    }
                }
                stringToDisplay.append("\n")
            }
    
            textView.text = stringToDisplay
        } else {
            stringToDisplay = "no way found"
            textView.text = stringToDisplay
        }
    }
    
}

