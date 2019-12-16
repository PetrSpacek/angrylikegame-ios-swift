//
//  Block.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 17/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

protocol BlockDelegate: class {
    func blockDestroyed(block: Block)
}

final class Block: GameObject, GameObjectCommonVisitor {
    var delegate: BlockDelegate?
    private let damageThreshold: Int
    
    // MARK: - Initialization
    init(size: CGSize, position: CGPoint, zRotation: CGFloat, name: String, health: Int) {
        damageThreshold = health/2
        
        super.init()
        self.score = 99
        self.name = name
        self.size = size
        self.position = position
        self.zRotation = zRotation
        self.health = health
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func accept(visitor: GameObjectVisitor) {
        visitor.visit(block: self)
    }
      
    func setPosition(position: CGPoint) {
        self.position = position
    }
    
    func setRotation(zRotation: CGFloat) {
        self.zRotation = zRotation
    }
    
    func getScore() -> Int {
        return score
    }
    
    func impact(with force: Int) {
        health -= force
        if health < 1 {
            delegate?.blockDestroyed(block: self)
        } else if health < damageThreshold {
            //delegate.
        }
    }
}
