//
//  HuaFengTests.swift
//  HuaFengTests
//
//  Created by Zhijie Chen on 8/20/18.
//  Copyright © 2018 Zhijie Chen. All rights reserved.
//

import XCTest
@testable import HuaFeng

class HuaFengTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let shelf = (try! MagazineService.shared.addShelf(withName: "My Shelf", andOrderIndex: 0))
        
        let testMag = MagazineService.shared.Magzines().fetchedObjects?.first!
        
        let numOfShelf = testMag?.shelf?.count
        testMag?.addToShelf(shelf)
        let newNumOfShelf = testMag?.shelf?.count
        
        XCTAssertGreaterThan(newNumOfShelf ?? -2, numOfShelf ?? -1)
        
        try! MagazineService.shared.deleteShelf(shelf)
        
        let deletedNumOfShelf = testMag?.shelf?.count
        XCTAssertEqual(deletedNumOfShelf ?? -2, numOfShelf ?? -1)
        
    }
    
}
