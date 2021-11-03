//
//  StructsTests.swift
//  StructsTests
//
//  Created by Hector Delgado on 11/2/21.
//

import XCTest
@testable import Structs

class StructsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLinkedListAppendCheckCount() throws {
        // Given
        var singlyLinkedList = SinglyLinkedList<Int>()
        let range = 1...10
        
        // When
        for i in range {
            singlyLinkedList.append(i)
        }
        
        // Then
        XCTAssert(singlyLinkedList.count == range.count)
    }
    
    func testLinkedListAppendCheckFirstNode() throws {
        // Given
        var singlyLinkedList = SinglyLinkedList<Int>()
        let range = 1...10
        
        // When
        for i in range {
            singlyLinkedList.append(i)
        }
        
        // Then
        XCTAssert(singlyLinkedList.first == range.first)
    }
    
    func testLinkedListAppendThenClear() throws {
        // Given
        var singlyLinkedList = SinglyLinkedList<Int>()
        
        // When
        for i in 1...10 {
            singlyLinkedList.append(i)
        }
        singlyLinkedList.clear()
        
        // Then
        XCTAssert(singlyLinkedList.first == nil && singlyLinkedList.count == 0)
    }
    
    

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
