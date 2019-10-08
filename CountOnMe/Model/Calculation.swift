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
   
    var expressionHaveResult: Bool {
        return numberString.firstIndex(of: "=") != nil
    }
    
    private var operandsArray = [String]()
    
    private var numbersArray = [String]()
    
    //MARK: - Calculation Function
    
    func solveEquation() -> String {
        
        for element in elements {
            if element.isConvertibleToInt() {
                numbersArray.append(element)
            } else {
                operandsArray.append(element)
            }
        }
        return getResult()
    }
    
    private func getResult() -> String {
           reduceOperation()
           let result = numbersArray[0].formatIfNeeded()
           
           numberString = "= \(result)"
           numbersArray.removeAll()
           
           return numberString
       }
    
    private func reduceToResult() {
        for (i, operand) in operandsArray.enumerated() {
            
            if operand == "-" || operand == "+" {
                guard let firstFloatNumber = Float(numbersArray[i]), let secondFloatNumber = Float(numbersArray[i + 1])  else {
                    return assertionFailure("Can't convert number in float")
                }
                
                if operand == "+" {
                    numbersArray = refreshNumberArray(at: i, firstFloatNumber + secondFloatNumber)
                    operandsArray = refreshOperandsArray(at: i)
                    
                    return reduceToResult()
                    
                } else if operand == "-" {
                    numbersArray = refreshNumberArray(at: i, firstFloatNumber - secondFloatNumber)
                    operandsArray = refreshOperandsArray(at: i)
                    
                    return reduceToResult()
                }
            }
        }
    }
    
    // Sign priority with Multiply and Divide
    
    private func reduceOperation() {
        
        for (i, operand) in operandsArray.enumerated() {
            if operand == "x" || operand == "/" {
                guard let firstFloatNumber = Float(numbersArray[i]), let secondFloatNumber = Float(numbersArray[i + 1]) else {
                    return assertionFailure("Can't convert number in float")
                }
                if operand == "x" {
                    numbersArray = refreshNumberArray(at: i, firstFloatNumber * secondFloatNumber)
                    operandsArray = refreshOperandsArray(at: i)
                    
                    return reduceOperation()
                } else if operand == "/" {
                    if secondFloatNumber == 0 {
                        
                        return  errorCaseDivideByZero()
                    }
                    else if secondFloatNumber != 0 {
                        numbersArray = refreshNumberArray(at: i, firstFloatNumber / secondFloatNumber)
                        operandsArray = refreshOperandsArray(at: i)
                        
                        return reduceOperation()
                    }
                }
            }
        }
        reduceToResult()
    }
    
    //MARK: - Setup

    //Refresh Numbers/Operands Array after remove element to get new and correct index
    
    private func refreshNumberArray(at i: Int,_ result: Float) -> [String]{
        
        numbersArray.remove(at: i + 1)
        numbersArray.remove(at: i)
        numbersArray.insert(String(result), at: i)
        
        return numbersArray
    }
    
    private func refreshOperandsArray(at i: Int) -> [String] {
        
        operandsArray.remove(at: i)
        
        return operandsArray
    }
    
    private func errorCaseDivideByZero() {
        sendNotification(name: "Can't divide by 0")
        operandsArray.removeAll()
        let error = ["ERROR"]
        numbersArray = error
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
