//
//  Calculation.swift
//  CountOnMe
//
//  Created by Thomas on 18/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculation {
    
    var numberString = String()
    
    var elements: [String] {
        return numberString.split(separator: " ").map{ "\($0)" }
    }
    
    // Error check computed variables
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "x"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "/" && elements.last != "x"
    }
    
    var expressionHaveResult: Bool {
        return numberString.firstIndex(of: "=") != nil
    }
    
    
    func solveEquation() -> String {
        
        var operationToReduce = elements
        
        while operationToReduce.count > 1 {
            
            guard let left = Int(operationToReduce[0]) else {
                break
            }
            
            let operand = operationToReduce[1]
            
            guard let right = Int(operationToReduce[2]) else {
                break
            }
            
            var result = 0
            
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "x": result = left * right
            case "/":
                if right == 0 {
                    sendNotification(name: "Can't divide by 0")
                    let error = "= ERROR"
                    numberString = error
                    return error
                } else {
                    result = left / right
                }
            default:
                return "ERROR"
            }
            
            operationToReduce = Array(operationToReduce.dropFirst(3))
            operationToReduce.insert("\(result)", at: 0)
        }
        guard let solution = operationToReduce.first else {
            return "Error"
        }
        print("result: \(solution)")
        
        numberString = " = \(solution)"
        return " = \(solution)"
    }
    
    func sendNotification(name: String) {
        let name = NSNotification.Name(name)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    
    func addToArray(_ data: String) {
        numberString.append(data)
    }
}
