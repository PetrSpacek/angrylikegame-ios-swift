//
//  BirdMock.swift
//  AngryBirdsADPTests
//
//  Created by Rostislav Babáček on 24/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit
@testable import AngryBirdsADP

class StrategyMock: BirdStrategy {
    var impulse = CGVector()
    var wasCalled = false
    
    func fly(_ bird: Bird, impulse: CGVector) {
        wasCalled = true
        self.impulse = impulse
    }
}

class BirdMock {
    var bird: Bird
    var strategy: StrategyMock
    
    init() {
        strategy = StrategyMock()
        bird = Bird(name: "Red", type: .red, strategy: strategy)
    }
}
