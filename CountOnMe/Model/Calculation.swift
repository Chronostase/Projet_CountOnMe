//
//  Calculation.swift
//  CountOnMe
//
//  Created by Thomas on 18/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.

import Foundation

class Calculation {
    
    //MARK: - Properties
    
    var numberString = String()
    
    var elements: [String] {
        return numberString.split(separator: " ").map{ "\($0)" }
    }
    
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
    
    private var operandsArray = [String]()
    
    private var numbersArray = [String]()
    //MARK: - Function
    
    func solveEquation() -> String {
        
//        var operandsArray = [String]()
//        var numberArray = [String]()
        
        for element in elements {
            if element.isConvertibleToInt() {
                numbersArray.append(element)
            } else {
                operandsArray.append(element)
            }
        }
        guard let newArray = reduceToResult() else {
            return "error"
        }
        
        let result = newArray[0]
        numberString = " = \(result[0])"
        return String(" = \(result[0])")
    }
    
    private func reduceToResult() -> [[String]]? {
        guard let newArray = reduceOperation() else {
            return nil
        }
        
        var result = 0
        var newNumberArray = newArray[0]
        var newOperandsArray = newArray[1]
        for (i, operand) in newOperandsArray.enumerated() {
            
            if operand == "-" || operand == "+" {
                guard let firstIntNumber = Int(newNumberArray[i]), let secondIntNumber = Int(newNumberArray[i + 1])  else {
                    return nil
                }
                
                if operand == "+" {
                    result = firstIntNumber + secondIntNumber
                    newNumberArray = refresh(at: i, result)
                    newOperandsArray = refreshThe(at: i)
                    
                    return reduceToResult()
                    
                } else if operand == "-" {
                    
                    result = firstIntNumber - secondIntNumber
                    newNumberArray = refresh(at: i, result)
                    newOperandsArray = refreshThe(at: i)
                    
                    return reduceToResult()
                }
            }
        }
        return [newNumberArray, newOperandsArray]
    }
    
    private func reduceOperation() -> [[String]]? {
//        var newNumberArray = numberArray
//        var newOperandsArray = operandsArray
        
        for (i, operand) in operandsArray.enumerated() {
            if operand == "x" || operand == "/" {
                guard let firstIntNumber = Int(numbersArray[i]), let secondIntNumber = Int(numbersArray[i + 1]) else {
                    return nil
                }
                
                if operand == "x" {
                    let result = firstIntNumber * secondIntNumber
                    numbersArray = refresh(at: i, result)
                    operandsArray = refreshThe(at: i)
                    
                    return reduceOperation()
                } else if operand == "/" {
                    if secondIntNumber == 0 {
                        errorCaseDivideByZero()
                        
                        return nil
                    } else {
                        let result = firstIntNumber / secondIntNumber
                        numbersArray = refresh(at: i, result)
                        operandsArray = refreshThe(at: i)
                        
                        return reduceOperation()
                    }
                }
            }
        }
        return [numbersArray, operandsArray]
    }
    
    //MARK: - Setup
    
    private func refresh(at i: Int,_ result: Int) -> [String]{
//        var newNumberArray = numberArray
        
        numbersArray.remove(at: i + 1)
        numbersArray.remove(at: i)
        numbersArray.insert(String(result), at: i)
        
        return numbersArray
    }
    
    private func refreshThe(at i: Int) -> [String] {
        
        operandsArray.remove(at: i)
        
        return operandsArray
    }
    
    private func errorCaseDivideByZero () {
        sendNotification(name: "Can't divide by 0")
        let error = "= ERROR"
        numberString = error
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
