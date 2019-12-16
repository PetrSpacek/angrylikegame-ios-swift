//
//  BlockMock.swift
//  AngryBirdsADPTests
//
//  Created by Rostislav Babáček on 24/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit
@testable import AngryBirdsADP

class BlockMock {
    var block: Block
    
    init() {
        let size = CGSize(width: 50, height: 50)
        let position = CGPoint(x: 55, y: 80)
        let zRotation = CGFloat(1.57)
        let name = "Block"
        let health = 100
        
        block = Block(size: size, position: position, zRotation: zRotation, name: name, health: health)
    }
}
