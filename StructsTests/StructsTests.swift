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
    
    func testAppendInLinkedListCount() throws {
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
    
    func

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
