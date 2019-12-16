//
//  Bird.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 10/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

protocol BirdDelegate: class {
    func birdFly(_ bird: Bird, impulse: CGVector, gravity: Bool)
}

enum BirdType: String, CaseIterable {
    case red, purple, yellow, gray, black
    
    var texture: String {
        switch self {
        
        case .red:
            return "birdRed"
        case .purple:
            return "birdPurple"
        case .yellow:
            return "birdYellow"
        case .black:
            return "birdBlack"
        case .gray:
            return "birdSpice"
        }
    }
}

final class Bird: GameObject, GameObjectCommonVisitor {
    let birdType: BirdType
    var delegate: BirdDelegate?
    private let strategy: BirdStrategy
    private var gravity: Bool = true
    
    private var grabbed = false
    private var flying = false
    
    // MARK: - Initialization
    init(name: String, type: BirdType, strategy: BirdStrategy) {
        self.strategy = strategy
        let type = type
        
        birdType = type
        super.init()
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func accept(visitor: GameObjectVisitor) {
        visitor.visit(bird: self)
     }
    
    func setPosition(position: CGPoint) {
        self.position = position
    }
    
    func fly(to targetPosition: CGPoint) {
        flying = true
        grabbed = false
        
        let dx = targetPosition.x - position.x
        let dy = targetPosition.y - position.y
        let impulse = CGVector(dx: dx, dy: dy)
        
        strategy.fly(self, impulse: impulse)
    }
    
    func getReady() {
        grabbed = true
    }
    
    func isGrabbed() -> Bool {
        return grabbed
    }
    
    func setFlying(_ value: Bool) {
        flying = value
    }
    
    func isFlying() -> Bool {
        return flying
    }
    
    func setGravity(value: Bool) {
        gravity = value
    }
    
    func hasGravity() -> Bool {
        return gravity
    }
}
