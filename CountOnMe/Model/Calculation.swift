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
    
    var numbersArray = [String]()
    
    //MARK: - Function
    
    func solveEquation() -> String {
        
        for element in elements {
            if element.isConvertibleToInt() {
                numbersArray.append(element)
            } else {
                operandsArray.append(element)
            }
            print(operandsArray)
            print(numbersArray)
            print(numberString)
        }
        return getResult()
    }
    
    private func reduceToResult() {
        for (i, operand) in operandsArray.enumerated() {
            
            if operand == "-" || operand == "+" {
                guard let firstIntNumber = Int(numbersArray[i]), let secondIntNumber = Int(numbersArray[i + 1])  else {
                    return
                }
                
                if operand == "+" {
                    numbersArray = refresh(at: i, firstIntNumber + secondIntNumber)
                    operandsArray = refreshThe(at: i)
                    
                    return reduceToResult()
                    
                } else if operand == "-" {
                    numbersArray = refresh(at: i, firstIntNumber - secondIntNumber)
                    operandsArray = refreshThe(at: i)
                    
                    return reduceToResult()
                }
            }
        }
    }
    
    private func reduceOperation() {
        
        for (i, operand) in operandsArray.enumerated() {
            if operand == "x" || operand == "/" {
                guard let firstIntNumber = Int(numbersArray[i]), let secondIntNumber = Int(numbersArray[i + 1]) else {
                    
                    return
                }
                if operand == "x" {
                    numbersArray = refresh(at: i, firstIntNumber * secondIntNumber)
                    operandsArray = refreshThe(at: i)
                    
                    return reduceOperation()
                } else if operand == "/" {
                    if secondIntNumber == 0 {
                        
                        return  errorCaseDivideByZero()
                    }
                    else if secondIntNumber != 0 {
                        numbersArray = refresh(at: i, firstIntNumber / secondIntNumber)
                        operandsArray = refreshThe(at: i)
                        
                        return reduceOperation()
                    }
                }
            }
        }
        reduceToResult()
    }
    
    //MARK: - Setup
    
    private func getResult() -> String {
        reduceOperation()
        numberString = "= \(numbersArray[0])"
        numbersArray.removeAll()
        
        return numberString
    }
    
    private func refresh(at i: Int,_ result: Int) -> [String]{
        
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
