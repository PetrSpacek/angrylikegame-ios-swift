//
//  GameModelTests.swift
//  AngryBirdsADPTests
//
//  Created by Rostislav Babáček on 24/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import XCTest
import SpriteKit
@testable import AngryBirdsADP

final class MockStrategy: BirdStrategy {
    var wasCalled = false
    func fly(_ bird: Bird, impulse: CGVector) {
        wasCalled = true
    }
}

final class MockFactory: GameObjectsFactory {
    var wasCalled = false
    func createBird(name: String, type: BirdType) -> Bird {
        wasCalled = true
        
        return Bird(name: name, type: type, strategy: MockStrategy())
    }
}

class GameModelTests: XCTestCase {
    var gameModel: GameModel!
    var birdsConf: [BirdConfiguration]!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        birdsConf = [ BirdConfiguration(name: "red", type: .red), BirdConfiguration(name: "yellow", type: .yellow) ]
        gameModel = GameModel.shared
        gameModel.birds = birdsConf
        gameModel.factory = MockFactory()
        gameModel.scene = GameScene()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateBird() {
        XCTAssertNil(gameModel.getBird())
        
        gameModel.createBird()
        
        XCTAssertNotNil(gameModel.getBird())
        XCTAssertEqual(gameModel.getBird()?.name, birdsConf[0].name)
    }
    
    func testSetBirdPosition() {
        let position = CGPoint(x: 90, y: 90)
        gameModel.createBird()
        gameModel.setBirdPosition(on: position, name: "red")
        
        XCTAssertEqual(gameModel.getBirdByName(name: "red")?.getPosition(), position)
    }
    
    func testFlyingBird() {
        gameModel.createBird()
        guard let bird = gameModel.getBirdByName(name: "red") else { return XCTFail() }
        
        bird.setFlying(true)
        XCTAssertTrue(gameModel.isBirdFlying(name: bird.name))
        
        gameModel.stopBird(with: bird.name)
        XCTAssertFalse(gameModel.isBirdFlying(name: bird.name))
    }
}
