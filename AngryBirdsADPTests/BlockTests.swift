//
//  AngryBirdsADPTests.swift
//  AngryBirdsADPTests
//
//  Created by Rostislav Babáček on 10/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import XCTest
@testable import AngryBirdsADP

class BlockTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBlockImpact() {
        let block = BlockMock().block
        let initialHealth = 150
        let impact = 50
        
        block.health = initialHealth
        
        XCTAssertEqual(block.health, initialHealth)
        
        block.impact(with: impact)
        XCTAssertEqual(block.health, initialHealth - impact)
    }
    
    func testGetScore() {
        let block = BlockMock().block
        
        XCTAssertEqual(block.getScore(), block.score)
    }
    
    func testSetPosition() {
        let block = BlockMock().block
        let position = CGPoint(x: 11, y: 99)
    
        block.setPosition(position: position)
        
        XCTAssertEqual(block.position, position)
    }

    func testSetRotation() {
        let block = BlockMock().block
        let rotation = CGFloat(1.33)
        
        block.setRotation(zRotation: rotation)
        
        XCTAssertEqual(block.zRotation, rotation)
    }
    
}
