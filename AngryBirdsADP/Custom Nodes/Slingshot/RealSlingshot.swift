//
//  Slingshot.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 23/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

protocol Slingshot {
    func accept(visitor: GameObjectVisitor)
    func setPosition(position: CGPoint)
    func shoot(location: CGPoint, bird: Bird)
    func doubleShoot()
}

final class RealSlingshot: GameObject, GameObjectCommonVisitor, Slingshot {
    private var state: SlingshotState = SingleSlingshotState()

    // MARK: - Initialization
    override init() {
        super.init()
        name = "slingshot"
        size = CGSize(width: 30, height: 90)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func accept(visitor: GameObjectVisitor) {
        visitor.visit(slingshot: self)
    }
    
    func setPosition(position: CGPoint) {
        self.position = position
    }
    
    func shoot(location: CGPoint, bird: Bird) {
        state.fire(bird: bird, from: self, to: location)
        state = SingleSlingshotState()
    }
    
    func doubleShoot() {
        state = DoubleSlingshotState()
    }
    
    func getState() -> SlingshotState {
        return state
    }
}
