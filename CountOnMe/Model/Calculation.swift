//
//  Calculation.swift
//  CountOnMe
//
//  Created by Thomas on 18/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.

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
    
    
//    func solveEquation() -> String {
//
//        var operationToReduce = elements
//        while operationToReduce.count > 1 {
//
//            guard let left = Int(operationToReduce[0]) else {
//                break
//            }
//
//            let operand = operationToReduce[1]
//
//            guard let right = Int(operationToReduce[2]) else {
//                break
//            }
//            guard let result = calculateResult(left, operand, right) else {
//                return "Error"
//            }
//
//            operationToReduce = Array(operationToReduce.dropFirst(3))
//            operationToReduce.insert("\(result)", at: 0)
//        }
//        guard let solution = operationToReduce.first else {
//            return "Error"
//        }
//
//        numberString = " = \(solution)"
//        return " = \(solution)"
//    }
    
    func solveEquation() -> String {
        
        var operandsArray = [String]()
        var numberArray = [String]()
        
        for element in elements {
            if element.isConvertibleToInt() {
                numberArray.append(element)
            } else {
                operandsArray.append(element)
            }
        }

        print("initial arrays: \(operandsArray), \(numberArray)")
        guard let newArray = test(numberArray: numberArray, operandsArray: operandsArray) else {
            return "error"
        }
        
        let result = newArray[0]
        numberString = " = \(result[0])"
        return String(" = \(result[0])")
    }
    
    private func test(numberArray: [String], operandsArray: [String]) -> [[String]]? {
        guard let newArray = reduceOperation(of: numberArray, and: operandsArray) else {
            return nil
        }
        
        print(newArray)
        print("=)")
        var result = 0
        var newNumberArray = newArray[0]
        var newOperandsArray = newArray[1]
        for (i, operand) in newOperandsArray.enumerated() {
            
            if operand == "-" || operand == "+" {
                guard let firstIntNumber = Int(newNumberArray[i]) else {
                    return nil
                }
                
                guard let secondIntNumber = Int(newNumberArray[i + 1]) else {
                    return nil
                    
                }
                
                switch operand {
                case "+" :
                    result = firstIntNumber + secondIntNumber
                    newNumberArray.remove(at: i)
                    newNumberArray.remove(at: i)
                    newOperandsArray.remove(at: i)
                    print(newNumberArray)
                    print(newOperandsArray)
                    
                    newNumberArray.insert(String(result), at: i)
                    return test(numberArray: newNumberArray, operandsArray: newOperandsArray)
                case "-" :
                    result = firstIntNumber - secondIntNumber
                    newNumberArray.remove(at: i)
                    newNumberArray.remove(at: i)
                    newOperandsArray.remove(at: i)
                    
                    newNumberArray.insert(String(result), at: i)
                    return test(numberArray: newNumberArray, operandsArray: newOperandsArray)
                    
                default :
                    return nil
                }
            }
        }
        return [newNumberArray, newOperandsArray]
    }
    // numberArray origine = Int
    private func reduceOperation(of numberArray: [String], and operandsArray: [String]) -> [[String]]? {
        var newNumberArray = numberArray
        var newOperandsArray = operandsArray
        
        
        for (i, operand) in operandsArray.enumerated() {
            if operand == "x" || operand == "/" {
                guard let firstIntNumber = Int(numberArray[i]) else {
                    return nil
                }
                guard let secondIntNumber = Int(numberArray[i + 1]) else {
                    return nil
                }
                switch operand {
                case "x":
                    print("Multiply get")
                    print(newNumberArray)
                    print("index: \(i)")
                    
                    let result = firstIntNumber * secondIntNumber
                    newNumberArray.remove(at: i)
                    newNumberArray.remove(at: i)
                    newOperandsArray.remove(at: i)
                    
                    newNumberArray.insert(String(result), at: i)
                    
                    return reduceOperation(of: newNumberArray, and: newOperandsArray)
                    
                case "/":
                    print("Divide get")
                    print(newNumberArray)
                    print("index: \(i)")
                    if secondIntNumber == 0 {
                        sendNotification(name: "Can't divide by 0")
                        let error = "= ERROR"
                        numberString = error
                        return nil
                    } else {
                        let result = firstIntNumber / secondIntNumber
                        newNumberArray.remove(at: i)
                        newNumberArray.remove(at: i)
                        newOperandsArray.remove(at: i)
                        
                        newNumberArray.insert(String(result), at: i)
                        
                        return reduceOperation(of: newNumberArray, and: newOperandsArray)
                    }
//                    let result = firstIntNumber / secondIntNumber
                    
                    
                default:
                    return nil
                }
            }
        }
        
        return [newNumberArray, newOperandsArray]
    }
    
    private func calculateResult(_ left: Int,_ operand: String,_ right: Int) -> Int? {
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
                return nil
            } else {
                result = left / right
            }
        default:
            return nil
        }
        return result
    }
    
    private func sendNotification(name: String) {
        let name = NSNotification.Name(name)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    
    func addToArray(_ data: String) {
        numberString.append(data)
    }
}

extension String {
    func isConvertibleToInt() -> Bool {
        return Int(self) != nil
    }
}
