//
//  Enemy.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 23/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

protocol EnemyDelegate: class {
    func removeEnemy(_ enemy: Enemy)
}

final class Enemy: GameObject, GameObjectCommonVisitor {
    var delegate: EnemyDelegate?
    
    // MARK: - Initialization
    override init() {
        super.init()
        score = 666
        name = "enemy"
    }
    
    // MARK: - Clone
    
    func clone() -> Enemy {
        return self.copy() as! Enemy
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = Enemy()
        copy.position = position
        copy.name = name
        copy.health = health
        copy.delegate = delegate
        
        return copy
    }
    
    // MARK: - Helpers
    
    func accept(visitor: GameObjectVisitor) {
        visitor.visit(enemy: self)
    }
    
    func setPosition(position: CGPoint) {
        self.position = position
    }
    
    func getScore() -> Int {
        return score
    }
    
    func impact(to index: Int, with force: Int) {
        health -= force
        if health < 1 {
            delegate?.removeEnemy(self)
        }
    }
}
