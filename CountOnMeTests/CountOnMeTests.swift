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
    
    func testGivenElementsCountIsZero_WhenAddingNumberAndOperator_ThenCountShouldBeTwooAndCanAddOperatorIsTrue() {
        calculation.addToArray("1")
        if calculation.canAddOperator {
            calculation.addToArray(" + ")
        }
        
        let elements = calculation.elements
        
        XCTAssertEqual(elements.count, 2)
    }
    
    func testGivenThereIsOperator_WhenCheckingIfCanAddOperator_ThenAddOperatorShouldBeFalse() {
        calculation.addToArray(" + ")
        
        let result = calculation.canAddOperator
        
        XCTAssertFalse(result)
    }
    
    func testGivenElementsCountIsOne_WhenAddingMinus_ThenCountShouldBeTwo() {
        calculation.addToArray("1")
        calculation.addToArray(" - ")
        
        let elements = calculation.elements
        
        XCTAssertEqual(elements.count, 2)
    }
    
    func testGivenElementsCountIsTwo_WhenAddingNumber_ThenCountShouldBeThree() {
        calculation.addToArray("1")
        calculation.addToArray(" + ")
        
        calculation.addToArray("1")
        
        let elements = calculation.elements
        
        XCTAssertEqual(elements.count, 3)
    }
    
    func testGivenElementsCountIsThree_WhenCheckExpressionHaveEnoughElement_ThenExpressionHaveEnoughElementShouldBeTrue() {
        calculation.addToArray("1")
        calculation.addToArray(" + ")
        calculation.addToArray("1")
        
        let result = calculation.expressionHaveEnoughElement
        
        XCTAssertTrue(result)
    }
    
    func testGivenElementsCOuntIsTwoo_WhenCheckExpressionHaveEnoughElement_ThenExpressionHaveEnoughElementShouldBeFalse() {
        calculation.addToArray("1")
        calculation.addToArray(" + ")
        
        let result = calculation.expressionHaveEnoughElement
        
        XCTAssertFalse(result)
    }
    
    func testGivenElementsCountIsThree_WhenCheckIfExpressionIsCorrect_ThenExpressionIsCorrectShouldBeTrue() {
        calculation.addToArray("1")
        calculation.addToArray(" + ")
        calculation.addToArray("1")
        
        let result = calculation.expressionIsCorrect
        
        XCTAssertTrue(result)
    }
    
    func testGivenElementsCountIsTwoo_WhenCheckIfExpressionIsCorrect_ThenExpressionIsCorrectShouldBeFalse() {
        calculation.addToArray("1")
        calculation.addToArray(" + ")
        
        let result = calculation.expressionIsCorrect
        
        XCTAssertFalse(result)
    }
    
    func testGivenElementsCountIsThreeAndOperandisMinus_WhenPressEqual_ThenResultShouldBeZero() {
        calculation.addToArray("1")
        calculation.addToArray(" - ")
        calculation.addToArray("1")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, " = 0")
    }
    
    func testGivenElementsCountIsThreeAndOperandisPlus_WhenPressEqual_ThenResultShouldBeTwoo() {
        calculation.addToArray("1")
        calculation.addToArray(" + ")
        calculation.addToArray("1")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, " = 2")
    }
    
    func testGivenElementsCountIsThreeAndOperandisMultiply_WhenPressEqual_ThenResultShouldBeOne() {
        calculation.addToArray("1")
        calculation.addToArray(" x ")
        calculation.addToArray("1")
        
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, " = 1")
    }
    
    func testGivenElementsCountIsThreeAndOperandisUnknowOperator_WhenPressEqual_ThenResultShouldBeUnknownOperator() {
        calculation.addToArray("1")
        calculation.addToArray(" ! ")
        calculation.addToArray("1")
        
        let result = calculation.solveEquation()
        let element = calculation.elements
        
        XCTAssertEqual(element.count, 3)
        XCTAssertNotEqual(result.count, 1)
    }
    
    func testGivenElementsCountIsTwoo_WhenPressEqual_ThenShouldEnterInBreak() {
        calculation.addToArray(" - ")
        calculation.addToArray(" - ")
        
        
        let element = calculation.elements
        let result = calculation.solveEquation()
        
        XCTAssertEqual(element.count, 2)
        XCTAssertNotEqual(result.count, 1)
    }
    
    func testGivenElementsCountIsThree_WhenPressEqual_ThenShouldEnterInBreak() {
        calculation.addToArray("1")
        calculation.addToArray(" - ")
        calculation.addToArray(" - ")
        
        
        let element = calculation.elements
        let result = calculation.solveEquation()
        
        XCTAssertEqual(element.count, 3)
        XCTAssertNotEqual(result.count, 1)
    }
    
    func testGivenThereIsNoElements_WhenSolveEquation_ThenSolutionShoulndBeEqualToElementFirst() {
        let result = calculation.solveEquation()
        
        XCTAssertEqual(result, "Error")
    }
    
    
    func testGivenElementsCountIsThreeAndPressEqual_WhenAddingNewElement_ThenNumberStringShouldOnlyContainNewElement() {
        
        calculation.addToArray("1")
        XCTAssertTrue(calculation.canAddOperator)
        calculation.addToArray(" / ")
        calculation.addToArray("1")
        if calculation.expressionHaveEnoughElement {
            if calculation.expressionIsCorrect {
                let _ = calculation.solveEquation()
            }
        }
        
        if calculation.expressionHaveResult {
            calculation.numberString.removeAll()
        }
        
        calculation.addToArray("1")
        
        let element = calculation.elements.count
        
        XCTAssertEqual(element, 1)
    }
    func testGivenElementsCountIsThreeAndRightElementsIsZero_WhenDivideAndPressEqual_ThenResultShouldBeError() {
        calculation.addToArray("1")
        if calculation.canAddOperator {
            calculation.addToArray(" / ")
        }
        calculation.addToArray("0")
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
}
