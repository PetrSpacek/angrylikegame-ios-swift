//
//  ProxySlingshot.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 21/11/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

final class ProxySlingshot: Slingshot {
    private let realSlingshot: RealSlingshot
    
    // MARK: - Initialization
    init() {
        realSlingshot = RealSlingshot()
    }
    
    // MARK: - Helpers
    func accept(visitor: GameObjectVisitor) {
        realSlingshot.accept(visitor: visitor)
    }
    
    func setPosition(position: CGPoint) {
        realSlingshot.setPosition(position: position)
    }
    
    func shoot(location: CGPoint, bird: Bird) {
        realSlingshot.shoot(location: location, bird: bird)
    }
    
    func doubleShoot() {
        realSlingshot.doubleShoot()
    }
    
    func getState() -> SlingshotState {
        return realSlingshot.getState()
    }
}
