//
//  Camera.swift
//  AngryBirdsADP
//
//  Created by Rostislav Babáček on 24/10/2019.
//  Copyright © 2019 Rostislav Babáček. All rights reserved.
//

import SpriteKit

class Camera: GameCamera, GameObjectCommonVisitor {
    
    // MARK: - Initialization
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func accept(visitor: GameObjectVisitor) {
        visitor.visit(camera: self)
    }
    
    func setPosition(position: CGPoint) {
        self.position = position
    }
}
