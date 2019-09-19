//
//  ViewController.swift
//  ViewController
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    
    let calculation = Calculation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addobserverWhenDivideByZero(name: "Can't divide by 0")
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var negativeButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    
    //MARK: - IBAction
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        checkExpressionHaveResult()
        negativeButton.tag = 1
        textView.text.append(numberText)
        calculation.numberString += numberText
    }
    
    @IBAction func tappedNegative(_ sender: UIButton) {
        checkExpressionHaveResult()
        if sender.tag == 0 {
            textView.text.append("-")
            calculation.numberString += ("-")
        } else {
            displayAlert("Need operator")
            
        }
        sender.tag = 1
    }
    
    @IBAction func tappedOperand(_ sender: UIButton) {
        
        guard let operand = sender.currentTitle else {
            return displayAlert("Can't receive information from sender.currenTitle")
        }
        if calculation.canAddOperator {
            addOperand("\(operand)")
        }
        
        negativeButton.tag = 0
    }
    
    @IBAction func tappedClear(_ sender: UIButton) {
            negativeButton.tag = 0
            textView.text.removeAll()
            calculation.numberString.removeAll()
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard calculation.expressionIsCorrect else {
            return displayAlert("There is not enough element to solve equation !")
        }
        
        guard calculation.expressionHaveEnoughElement else {
            print(calculation.numberString)
            print(calculation.elements)
            return displayAlert("Start a new calcul !")
        }
        
        textView.text = calculation.solveEquation()
    }
    
    private func addScripture(data: String ) {
        textView.text.append(data)
        calculation.addToArray(" \(data) ")
    }
    
    private func checkExpressionHaveResult() {
        if calculation.expressionHaveResult {
            negativeButton.tag = 0 
            textView.text.removeAll()
            calculation.numberString.removeAll()
        }
    }
    
    private func addOperand(_ operand: String) {
        if textView.text.isEmpty || calculation.expressionHaveResult {
            return displayAlert("A value is needed")
        }
        
        switch operand {
        case "+": addScripture(data: operand)
        case "-": addScripture(data: operand)
        case "x": addScripture(data: operand)
        case "/": addScripture(data: operand)
            
        default : displayAlert("An operand is already here !")
            
        }
    }
    
    //MARK: - Setup
    private func addobserverWhenDivideByZero(name: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(divideByZeroAlert), name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    @objc private func divideByZeroAlert() {
        displayAlert("Can't divide by zero")
    }
    
    private func displayAlert(_ message: String) {
        
        let alertVC = UIAlertController(title: "Error !", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
