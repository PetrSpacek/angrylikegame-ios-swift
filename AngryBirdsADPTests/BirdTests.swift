//
//  BirdTests.swift
//  AngryBirdsADPTests
//
//  Created by Rostislav Babáček on 24/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import XCTest
@testable import AngryBirdsADP

class BirdTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFly() {
        let birdMock = BirdMock()
        let bird = birdMock.bird
        let birdStrategy = birdMock.strategy
        
        bird.fly(to: CGPoint(x: 50, y: 50))
        
        XCTAssertEqual(bird.isGrabbed(), false)
        XCTAssertEqual(bird.isFlying(), true)
        
        XCTAssertTrue(birdStrategy.wasCalled)
    }
    
    func testFlyVector() {
        let birdMock = BirdMock()
        let bird = birdMock.bird
        let birdStrategy = birdMock.strategy
        let startPosition = CGPoint(x: 0, y: 0)
        let targetPosition = CGPoint(x: 50, y: 50)
        
        let vector = CGVector(dx: targetPosition.x - startPosition.x, dy: targetPosition.y - startPosition.y)
        
        bird.setPosition(position: startPosition)
        bird.fly(to: targetPosition)
        
        XCTAssertEqual(birdStrategy.impulse, vector)
    }
    
    func testSetGravityTrue() {
        let bird = BirdMock().bird
        
        bird.setGravity(value: true)
        
        XCTAssertTrue(bird.hasGravity())
    }
    
    func testSetGravityFalse() {
        let bird = BirdMock().bird
        
        bird.setGravity(value: false)
        
        XCTAssertFalse(bird.hasGravity())
    }
    
    func testSetFlying() {
        let bird = BirdMock().bird
        
        bird.setGravity(value: true)
        
        XCTAssertTrue(bird.hasGravity())
    }
    
    func testGetReady() {
        let bird = BirdMock().bird
        
        bird.getReady()
        
        XCTAssertTrue(bird.isGrabbed())
    }
}
