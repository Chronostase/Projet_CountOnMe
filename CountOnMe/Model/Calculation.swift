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
    
    //MARK: - Function
    
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
        guard let newArray = reduceToResult(numberArray: numberArray, operandsArray: operandsArray) else {
            return "error"
        }
        
        let result = newArray[0]
        numberString = " = \(result[0])"
        return String(" = \(result[0])")
    }

    private func reduceToResult(numberArray: [String], operandsArray: [String]) -> [[String]]? {
        guard let newArray = reduceOperation(of: numberArray, and: operandsArray) else {
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
                    newNumberArray = refresh(newNumberArray, at: i, result)
                    newOperandsArray = refreshThe(newOperandsArray, at: i)

                    return reduceToResult(numberArray: newNumberArray, operandsArray: newOperandsArray)
                } else if operand == "-" {
                result = firstIntNumber - secondIntNumber
                    newNumberArray = refresh(newNumberArray, at: i, result)
                    newOperandsArray = refreshThe(newOperandsArray, at: i)

                    return reduceToResult(numberArray: newNumberArray, operandsArray: newOperandsArray)
                }
            }
        }
        return [newNumberArray, newOperandsArray]
    }
    
    private func reduceOperation(of numberArray: [String], and operandsArray: [String]) -> [[String]]? {
        var newNumberArray = numberArray
        var newOperandsArray = operandsArray
        
        for (i, operand) in operandsArray.enumerated() {
            if operand == "x" || operand == "/" {
                guard let firstIntNumber = Int(numberArray[i]), let secondIntNumber = Int(numberArray[i + 1]) else {
                    return nil
                }
                
               if operand == "x" {
                    let result = firstIntNumber * secondIntNumber
                    newNumberArray = refresh(newNumberArray, at: i, result)
                    newOperandsArray = refreshThe(newOperandsArray, at: i)
                    
                    return reduceOperation(of: newNumberArray, and: newOperandsArray)
               } else if operand == "/" {
                    if secondIntNumber == 0 {
                        errorCaseDivideByZero()
                        
                        return nil
                    } else {
                        let result = firstIntNumber / secondIntNumber
                        newNumberArray = refresh(newNumberArray, at: i, result)
                        newOperandsArray = refreshThe(newOperandsArray, at: i)
                        
                        return reduceOperation(of: newNumberArray, and: newOperandsArray)
                    }
                }
            }
        }
        return [newNumberArray, newOperandsArray]
    }

    //MARK: - Setup
   
    private func refresh(_ numberArray: [String],at i: Int,_ result: Int) -> [String]{
        var newNumberArray = numberArray
        
        newNumberArray.remove(at: i + 1)
        newNumberArray.remove(at: i)
        newNumberArray.insert(String(result), at: i)
        
        return newNumberArray
    }
    
    private func refreshThe(_ operandsArray: [String],at i: Int) -> [String] {
        var newOperandsArray = operandsArray
        
        newOperandsArray.remove(at: i)
        
        return newOperandsArray
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

//MARK: - Extension

extension String {
    func isConvertibleToInt() -> Bool {
        return Int(self) != nil
    }
}
