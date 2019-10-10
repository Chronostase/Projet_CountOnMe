//
//  CountOnMeTests.swift
//  CountOnMeTests
//
//  Created by Thomas on 12/09/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CountOnMeTests: XCTestCase {
    
    var calculation: Calculation!
    
    override func setUp() {
        super.setUp()
        calculation = Calculation()
    }
    
    // Test number element / Expression is correct
    
    func testGivenElementsCountIsZero_WhenAddingNumberAndOperator_ThenCountShouldBeTwooAndExpressionIsCorrectIsTrue() {
        calculation.addData("1")
        XCTAssertTrue(calculation.expressionIsCorrect)
        calculation.addData(" + ")
        
        let elements = calculation.elements
        
        XCTAssertEqual(elements.count, 2)
    }
    
    func testGivenThereIsOperator_WhenCheckingIfExpressionIsCorrect_ThenExpressionIsCorrectShouldBeFalse() {
        calculation.addData(" + ")
        
        let result = calculation.expressionIsCorrect
        
        XCTAssertFalse(result)
    }
    
    func testGivenElementsCountIsOne_WhenAddingMinus_ThenCountShouldBeTwo() {
        calculation.addData("1")
        calculation.addData(" - ")
        
        let elements = calculation.elements
        
        XCTAssertEqual(elements.count, 2)
    }
    
    func testGivenElementsCountIsTwo_WhenAddingNumber_ThenCountShouldBeThree() {
        calculation.addData("1")
        calculation.addData(" + ")
        
        calculation.addData("1")
        
        let elements = calculation.elements
        
        XCTAssertEqual(elements.count, 3)
    }
    
    func testGivenElementsCountIsThree_WhenCheckExpressionHaveEnoughElement_ThenExpressionHaveEnoughElementShouldBeTrue() {
        calculation.addData("1")
        calculation.addData(" + ")
        calculation.addData("1")
        
        let result = calculation.expressionHaveEnoughElement
        
        XCTAssertTrue(result)
    }
    
    func testGivenElementsCOuntIsTwoo_WhenCheckExpressionHaveEnoughElement_ThenExpressionHaveEnoughElementShouldBeFalse() {
        calculation.addData("1")
        calculation.addData(" + ")
        
        let result = calculation.expressionHaveEnoughElement
        
        XCTAssertFalse(result)
    }
    
    func testGivenElementsCountIsThree_WhenCheckIfExpressionIsCorrect_ThenExpressionIsCorrectShouldBeTrue() {
        calculation.addData("1")
        calculation.addData(" + ")
        calculation.addData("1")
        
        let result = calculation.expressionIsCorrect
        
        XCTAssertTrue(result)
    }
    
    func testGivenElementsCountIsTwoo_WhenCheckIfExpressionIsCorrect_ThenExpressionIsCorrectShouldBeFalse() {
        calculation.addData("1")
        calculation.addData(" + ")
        
        let result = calculation.expressionIsCorrect
        
        XCTAssertFalse(result)
    }
    
    func testGivenElementsCountIsThreeAndPressEqual_WhenAddingNewElement_ThenNumberStringShouldOnlyContainNewElement() {
        
        calculation.addData("1")
        XCTAssertTrue(calculation.expressionIsCorrect)
        calculation.addData(" / ")
        calculation.addData("1")
        if calculation.expressionHaveEnoughElement {
            if calculation.expressionIsCorrect {
                let _ = calculation.solveEquation()
            }
        }
        
        if calculation.expressionHaveResult {
            calculation.numberString.removeAll()
        }
        
        calculation.addData("1")
        
        let element = calculation.elements.count
        
        XCTAssertEqual(element, 1)
    }
    
    // Calculation test
    
    func testGivenElementsCountIsThreeAndOperandisMinus_WhenSolveEquation_ThenResultShouldBeZero() {
        calculation.addData("1")
        calculation.addData(" - ")
        calculation.addData("1")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, "= 0")
    }
    
    func testGivenElementsCountIsThreeAndOperandisPlus_WhenSolveEquation_ThenResultShouldBeTwoo() {
        calculation.addData("1")
        calculation.addData(" + ")
        calculation.addData("1")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, "= 2")
    }
    
    func testGivenElementsCountIsThreeAndOperandisMultiply_WhenSolveEquation_ThenResultShouldBeOne() {
        calculation.addData("1")
        calculation.addData(" x ")
        calculation.addData("1")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, "= 1")
    }
    
    func testGivenElementsCountIsThreeAndRightElementsIsZero_WhenDivideAndPressEqual_ThenResultShouldBeError() {
        calculation.addData("1")
        if calculation.expressionIsCorrect {
            calculation.addData(" / ")
        }
        calculation.addData("0")
        if calculation.expressionHaveEnoughElement {
            if calculation.expressionIsCorrect {
                let _ = calculation.solveEquation()
                XCTAssertEqual(calculation.numberString, "= ERROR")
            }
            if calculation.expressionHaveResult {
                calculation.numberString.removeAll()
            }
        }
    }
    
    // Complexe operation
    
    func testGivenThereIsComplexOperationWithMultipleOperator_WhenSolveEquation_ThenShouldHaveGoodResult() {
        calculation.addData("2")
        calculation.addData(" + ")
        calculation.addData("3")
        calculation.addData(" x ")
        calculation.addData("6")
        calculation.addData(" / ")
        calculation.addData("2")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, "= 11")
    }
    
    // Test negative number
    
    func testGivenThereIsSimpleOperationwithNegativeNumber_WhenSolveEquation_ThenResultShouldBeRight() {
        calculation.addData("1")
        calculation.addData(" - ")
        calculation.addData("-1")
        calculation.addData(" x ")
        calculation.addData("-2")
        calculation.addData(" / ")
        calculation.addData("-2")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, "= 2")
    }
    
    // Test comma
    
    func testGivenDivideUnevenNumber_WhenSolveEquation_ThenResultShouldHaveComma() {
        calculation.addData("3")
        calculation.addData(" / ")
        calculation.addData("2")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, "= 1.5")
    }
}
